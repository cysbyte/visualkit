import Foundation

enum JobServiceError: LocalizedError {
    case failed(String)
    case cancelled
    case timedOut

    var errorDescription: String? {
        switch self {
        case .failed(let message):
            return message
        case .cancelled:
            return "The job was cancelled."
        case .timedOut:
            return "The job took too long. Try again."
        }
    }
}

protocol JobService: Sendable {
    func createJob<Request: Codable & Sendable, Result: Codable & Hashable & Sendable>(
        _ request: Request,
        kind: JobKind
    ) async throws -> Job<Result>
    func getJobStatus<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>
    ) async throws -> Job<Result>
    func waitForCompletion<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>,
        pollingInterval: Duration,
        timeout: Duration
    ) async throws -> Job<Result>
    func cancelJob<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>
    ) async throws
}

extension JobService {
    func waitForCompletion<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>,
        pollingInterval: Duration = .seconds(1.5)
    ) async throws -> Job<Result> {
        try await waitForCompletion(
            job,
            pollingInterval: pollingInterval,
            timeout: .seconds(10 * 60)
        )
    }

    func waitForCompletion<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>,
        pollingInterval: Duration,
        timeout: Duration = .seconds(10 * 60)
    ) async throws -> Job<Result> {
        var currentJob = job
        let deadline = ContinuousClock.now.advanced(by: timeout)
        var transientFailures = 0

        while !currentJob.status.isTerminal {
            try Task.checkCancellation()
            guard ContinuousClock.now < deadline else {
                throw APIError.timedOut
            }
            try await Task.sleep(for: pollingInterval)
            try Task.checkCancellation()
            do {
                currentJob = try await getJobStatus(currentJob)
                transientFailures = 0
            } catch {
                guard isTransientPollingError(error), transientFailures < 4 else {
                    throw APIError.map(error, operation: currentJob.kind == .imageAnalysis ? .analysis : .generation)
                }
                transientFailures += 1
                let retryDelay = min(
                    pollingInterval.secondsValue * pow(2, Double(transientFailures)),
                    8
                )
                try await Task.sleep(for: .seconds(retryDelay))
            }
        }

        switch currentJob.status {
        case .completed:
            return currentJob
        case .cancelled:
            throw APIError.cancelled
        case .failed:
            if currentJob.kind == .imageAnalysis {
                throw APIError.analysisFailed(currentJob.errorMessage ?? "The analysis failed.")
            }
            throw APIError.generationFailed(currentJob.errorMessage ?? "The generation failed.")
        case .queued, .processing:
            throw JobServiceError.failed("The job ended in an invalid state.")
        }
    }

    private func isTransientPollingError(_ error: Error) -> Bool {
        switch APIError.map(error, operation: .request) {
        case .networkUnavailable, .unavailable, .timedOut:
            return true
        default:
            return false
        }
    }
}

private extension Duration {
    var secondsValue: Double {
        let components = components
        return Double(components.seconds) + Double(components.attoseconds) / 1_000_000_000_000_000_000
    }
}

struct RemoteJobService: JobService {
    let api: any JobAPI

    func createJob<Request: Codable & Sendable, Result: Codable & Hashable & Sendable>(
        _ request: Request,
        kind: JobKind
    ) async throws -> Job<Result> {
        switch kind {
        case .imageAnalysis:
            guard let input = request as? ImageAnalysisRequest,
                  let assetID = input.assetID else {
                throw APIError.invalidRequest("A reference image upload is required.")
            }
            let reference = try await api.analyzeImage(assetID: assetID)
            return Job(id: reference.id, kind: kind, status: reference.status)
        case .imageGeneration:
            guard let input = request as? ImageGenerationRequest else {
                throw APIError.invalidRequest("The generation request is invalid.")
            }
            let reference = try await api.generateImage(
                request: input,
                idempotencyKey: input.idempotencyKey
            )
            return Job(id: reference.id, kind: kind, status: reference.status)
        }
    }

    func getJobStatus<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>
    ) async throws -> Job<Result> {
        try await api.getJobStatus(jobID: job.id, kind: job.kind)
    }

    func cancelJob<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>
    ) async throws {
        try await api.cancel(jobID: job.id)
    }
}

struct MockAnalysisJobRequest: Codable, Sendable {
    let imageData: Data
    let filename: String
}

struct MockGenerationJobRequest: Codable, Sendable {
    let draft: GenerationDraft
}

struct MockJobService: JobService {
    func createJob<Request: Codable & Sendable, Result: Codable & Hashable & Sendable>(
        _ request: Request,
        kind: JobKind
    ) async throws -> Job<Result> {
        Job(id: UUID().uuidString, kind: kind)
    }

    func getJobStatus<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>
    ) async throws -> Job<Result> {
        try await Task.sleep(for: .milliseconds(250))
        if job.kind == .imageAnalysis {
            return Job(
                id: job.id,
                kind: job.kind,
                status: .completed,
                result: VisualDNA.sample as? Result
            )
        }
        return Job(id: job.id, kind: job.kind, status: .completed)
    }

    func cancelJob<Result: Codable & Hashable & Sendable>(
        _ job: Job<Result>
    ) async throws {}
}
