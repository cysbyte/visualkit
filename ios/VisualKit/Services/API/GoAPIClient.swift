import Foundation

final class GoAPIClient: BackendAPIClient, @unchecked Sendable {
    private let configuration: APIConfiguration
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        configuration: APIConfiguration,
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.session = session

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Self.decodeDate)
        self.decoder = decoder
    }

    private static func decodeDate(from decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        if let date = fractionalISO8601Formatter.date(from: value) ??
            wholeSecondISO8601Formatter.date(from: value) {
            return date
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Invalid ISO-8601 date: \(value)"
        )
    }

    private static let fractionalISO8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter
    }()

    private static let wholeSecondISO8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    func requestUploadURL(
        filename: String,
        contentType: String,
        sizeBytes: Int
    ) async throws -> AssetUploadAuthorization {
        try await request(
            method: "POST",
            path: "/v1/assets/upload-url",
            body: UploadURLRequest(
                filename: filename,
                contentType: contentType,
                sizeBytes: sizeBytes
            ),
            operation: .upload
        )
    }

    func completeUpload(
        assetID: UUID,
        objectKey: String,
        sizeBytes: Int,
        contentType: String,
        pixelWidth: Int,
        pixelHeight: Int
    ) async throws -> AssetRecord {
        try await request(
            method: "POST",
            path: "/v1/assets/\(assetID.uuidString)/complete",
            body: CompleteUploadRequest(
                objectKey: objectKey,
                sizeBytes: sizeBytes,
                contentType: contentType,
                pixelWidth: pixelWidth,
                pixelHeight: pixelHeight
            ),
            operation: .upload
        )
    }

    func downloadURL(for assetID: UUID) async throws -> SignedAssetURL {
        try await request(
            method: "GET",
            path: "/v1/assets/\(assetID.uuidString)/url",
            operation: .request
        )
    }

    func analyzeImage(assetID: UUID) async throws -> JobReference {
        try await request(
            method: "POST",
            path: "/v1/image-analysis",
            body: ImageAnalysisJobRequest(assetID: assetID),
            operation: .analysis
        )
    }

    func generateImage(
        request: ImageGenerationRequest,
        idempotencyKey: UUID
    ) async throws -> JobReference {
        guard let templateID = try await backendTemplateID(for: request.template) else {
            throw APIError.invalidRequest("Templates have not loaded from the backend.")
        }

        return try await requestAPI(
            method: "POST",
            path: "/v1/jobs/image-generation",
            body: BackendGenerationRequest(
                prompt: request.userPrompt,
                templateID: templateID,
                visualDNA: request.visualDNA,
                preservation: request.preservation,
                referenceAssetID: request.referenceAssetID ?? request.referenceImage?.assetID,
                generationSettings: request.settings
            ),
            headers: ["Idempotency-Key": idempotencyKey.uuidString],
            operation: .generation
        )
    }

    func getJobStatus<Result: Codable & Hashable & Sendable>(
        jobID: String,
        kind: JobKind
    ) async throws -> Job<Result> {
        let response: BackendJobResponse = try await request(
            method: "GET",
            path: "/v1/jobs/\(jobID)",
            operation: kind == .imageAnalysis ? .analysis : .generation
        )

        let resolvedID = response.id?.uuidString ?? response.jobID?.uuidString ?? jobID
        var result: Result?
        if kind == .imageAnalysis,
           let visualDNA = response.result?.visualDNA as? Result {
            result = visualDNA
        } else if kind == .imageGeneration,
                  let creationID = response.output?.creationID,
                  let uuid = UUID(uuidString: creationID),
                  let creation = try? await getCreation(id: uuid) as? Result {
            result = creation
        }

        return Job(
            id: resolvedID,
            kind: kind,
            status: response.status,
            result: result,
            errorMessage: response.errorMessage ?? response.errorCode,
            createdAt: response.createdAt ?? Date(),
            updatedAt: response.updatedAt ?? Date()
        )
    }

    func cancel(jobID: String) async throws {
        try await requestVoid(
            method: "POST",
            path: "/v1/jobs/\(jobID)/cancel",
            operation: .request
        )
    }

    func listStyles() async throws -> [SavedStyle] {
        let values: [BackendStyle] = try await request(
            method: "GET",
            path: "/v1/styles",
            operation: .request
        )
        return values.map(\.localStyle)
    }

    func getStyle(id: UUID) async throws -> SavedStyle {
        let value: BackendStyle = try await request(
            method: "GET",
            path: "/v1/styles/\(id.uuidString)",
            operation: .request
        )
        return value.localStyle
    }

    func createStyle(_ style: SavedStyle) async throws -> SavedStyle {
        let value: BackendStyle = try await requestAPI(
            method: "POST",
            path: "/v1/styles",
            body: BackendStyleRequest(
                name: style.name,
                visualDNA: style.dna,
                previewAssetID: style.previewAssetID
            ),
            operation: .request
        )
        return value.localStyle
    }

    func updateStyle(_ style: SavedStyle) async throws -> SavedStyle {
        let value: BackendStyle = try await requestAPI(
            method: "PATCH",
            path: "/v1/styles/\(style.id.uuidString)",
            body: BackendStyleRequest(
                name: style.name,
                visualDNA: style.dna,
                previewAssetID: style.previewAssetID
            ),
            operation: .request
        )
        return value.localStyle
    }

    func deleteStyle(id: UUID) async throws {
        try await requestVoid(
            method: "DELETE",
            path: "/v1/styles/\(id.uuidString)",
            operation: .request
        )
    }

    func listCreations(limit: Int, cursor: String?) async throws -> CreationPage {
        var path = "/v1/creations?limit=\(max(1, min(limit, 100)))"
        if let cursor, !cursor.isEmpty {
            let encoded = cursor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cursor
            path += "&cursor=\(encoded)"
        }
        let page: BackendCreationPage = try await request(
            method: "GET",
            path: path,
            operation: .request
        )
        return CreationPage(
            items: page.items.map(\.localCreation),
            nextCursor: page.nextCursor,
            hasMore: page.hasMore
        )
    }

    func getCreation(id: UUID) async throws -> Creation {
        let value: BackendCreation = try await request(
            method: "GET",
            path: "/v1/creations/\(id.uuidString)",
            operation: .request
        )
        return value.localCreation
    }

    func deleteCreation(id: UUID) async throws {
        try await requestVoid(
            method: "DELETE",
            path: "/v1/creations/\(id.uuidString)",
            operation: .request
        )
    }

    func listTemplates() async throws -> [Template] {
        let values: [BackendTemplate] = try await request(
            method: "GET",
            path: "/v1/templates",
            operation: .request
        )
        return values.map(\.localTemplate)
    }

    func getBalance() async throws -> CreditBalance {
        try await request(
            method: "GET",
            path: "/v1/credits/balance",
            operation: .request
        )
    }

    func estimate(templateID: UUID, aspectRatio: AspectRatio) async throws -> CreditEstimate {
        try await request(
            method: "GET",
            path: "/v1/generation/estimate?template_id=\(templateID.uuidString)&aspect_ratio=\(aspectRatio.rawValue)",
            operation: .request
        )
    }

    func analyzeReference(_ request: ImageAnalysisRequest) async throws -> VisualDNA {
        guard let assetID = request.assetID else {
            throw APIError.invalidRequest("Upload a reference image before analyzing it.")
        }
        let reference = try await analyzeImage(assetID: assetID)
        let job: Job<VisualDNA> = Job(id: reference.id, kind: .imageAnalysis, status: reference.status)
        let completed = try await RemoteJobService(api: self).waitForCompletion(
            job,
            pollingInterval: .seconds(1.5),
            timeout: .seconds(10 * 60)
        )
        guard let result = completed.result else {
            throw APIError.analysisFailed("The analysis returned no Visual DNA.")
        }
        return result
    }

    func generateImage(from request: ImageGenerationRequest) async throws -> Creation {
        let reference = try await generateImage(
            request: request,
            idempotencyKey: request.idempotencyKey
        )
        let job: Job<Creation> = Job(id: reference.id, kind: .imageGeneration, status: reference.status)
        let completed = try await RemoteJobService(api: self).waitForCompletion(
            job,
            pollingInterval: .seconds(1.5),
            timeout: .seconds(20 * 60)
        )
        guard let result = completed.result else {
            throw APIError.generationFailed("The generation returned no creation.")
        }
        return result
    }

    private func backendTemplateID(for template: Template) async throws -> UUID? {
        if let backendID = template.backendID {
            return backendID
        }
        let templates = try await listTemplates()
        return templates.first { candidate in
            candidate.id == template.id
                || candidate.id == template.backendSlugFallback
                || candidate.name.caseInsensitiveCompare(template.name) == .orderedSame
        }?.backendID
    }

    private func makeRequest(
        method: String,
        path: String,
        headers: [String: String] = [:],
        body: Data? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: configuration.baseURL)?.absoluteURL else {
            throw APIError.invalidRequest("The API address is invalid.")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = configuration.requestTimeout
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        if let bearerToken = configuration.bearerToken, !bearerToken.isEmpty {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        } else if let developmentUserID = configuration.developmentUserID {
            request.setValue(developmentUserID.uuidString, forHTTPHeaderField: "X-User-ID")
        }
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }

    private func request<T: Decodable>(
        method: String,
        path: String,
        operation: APIErrorOperation
    ) async throws -> T {
        try await requestAPI(
            method: method,
            path: path,
            bodyData: nil,
            headers: [:],
            operation: operation
        )
    }

    private func request<T: Decodable, Body: Encodable>(
        method: String,
        path: String,
        body: Body,
        operation: APIErrorOperation
    ) async throws -> T {
        try await requestAPI(
            method: method,
            path: path,
            body: body,
            headers: [:],
            operation: operation
        )
    }

    private func requestAPI<T: Decodable>(
        method: String,
        path: String,
        bodyData: Data?,
        headers: [String: String],
        operation: APIErrorOperation
    ) async throws -> T {
        let request = try makeRequest(method: method, path: path, headers: headers, body: bodyData)
        return try await perform(request, operation: operation)
    }

    private func requestAPI<T: Decodable, Body: Encodable>(
        method: String,
        path: String,
        body: Body,
        headers: [String: String] = [:],
        operation: APIErrorOperation
    ) async throws -> T {
        let data = try encoder.encode(body)
        let request = try makeRequest(method: method, path: path, headers: headers, body: data)
        return try await perform(request, operation: operation)
    }

    private func perform<T: Decodable>(
        _ request: URLRequest,
        operation: APIErrorOperation
    ) async throws -> T {
        do {
            let (data, response) = try await data(for: request, operation: operation)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            guard (200..<300).contains(response.statusCode) else {
                throw mapHTTPError(response, data: data)
            }
            let envelope = try decoder.decode(APIEnvelope<T>.self, from: data)
            guard let value = envelope.data else {
                throw APIError.invalidResponse
            }
            return value
        } catch let error as APIError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw APIError.map(error, operation: operation)
        }
    }

    private func requestVoid(
        method: String,
        path: String,
        operation: APIErrorOperation
    ) async throws {
        let request = try makeRequest(method: method, path: path)
        do {
            let (data, response) = try await data(for: request, operation: operation)
            guard let response = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            guard (200..<300).contains(response.statusCode) else {
                throw mapHTTPError(response, data: data)
            }
            _ = try decoder.decode(APIEnvelope<EmptyResponse>.self, from: data)
        } catch let error as APIError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw APIError.map(error, operation: operation)
        }
    }

    private func data(
        for request: URLRequest,
        operation: APIErrorOperation
    ) async throws -> (Data, URLResponse) {
        var attempt = 0
        var lastError: Error?

        while attempt < configuration.retryPolicy.maxAttempts {
            try Task.checkCancellation()
            attempt += 1

            do {
                let (data, response) = try await session.data(for: request)
                if let httpResponse = response as? HTTPURLResponse,
                   shouldRetry(statusCode: httpResponse.statusCode),
                   attempt < configuration.retryPolicy.maxAttempts {
                    try await sleepBeforeRetry(attempt: attempt)
                    continue
                }
                return (data, response)
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                lastError = error
                guard shouldRetry(error), attempt < configuration.retryPolicy.maxAttempts else {
                    throw error
                }
                try await sleepBeforeRetry(attempt: attempt)
            }
        }

        throw lastError ?? APIError.server(
            code: operation.rawValue,
            message: "The request could not be completed."
        )
    }

    private func sleepBeforeRetry(attempt: Int) async throws {
        let delay = min(
            configuration.retryPolicy.maxDelay,
            configuration.retryPolicy.baseDelay * pow(2, Double(max(0, attempt - 1)))
        )
        try await Task.sleep(for: .seconds(delay))
    }

    private func shouldRetry(statusCode: Int) -> Bool {
        statusCode == 408 || statusCode == 429 || (500..<600).contains(statusCode)
    }

    private func shouldRetry(_ error: Error) -> Bool {
        guard let urlError = error as? URLError else { return false }
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost,
             .cannotConnectToHost, .dnsLookupFailed, .timedOut:
            return true
        default:
            return false
        }
    }

    private func mapHTTPError(_ response: HTTPURLResponse, data: Data) -> APIError {
        let envelope = try? decoder.decode(APIEnvelope<EmptyResponse>.self, from: data)
        if let error = envelope?.error {
            return mapServerError(error)
        }
        switch response.statusCode {
        case 401:
            return .authenticationRequired
        case 403:
            return .unauthorized
        case 404:
            return .notFound
        case 408:
            return .timedOut
        case 402:
            return .insufficientCredits
        case 429, 500..<600:
            return .unavailable
        default:
            return .invalidResponse
        }
    }

    private func mapServerError(_ error: APIErrorBody?) -> APIError {
        guard let error else { return .invalidResponse }
        switch error.code {
        case "INVALID_REQUEST": return .invalidRequest(error.message)
        case "INSUFFICIENT_CREDITS": return .insufficientCredits
        case "UNAUTHORIZED": return .authenticationRequired
        case "INVALID_CREDENTIALS": return .unauthorized
        case "NOT_FOUND": return .notFound
        case "QUEUE_UNAVAILABLE", "SERVICE_UNAVAILABLE": return .unavailable
        default: return .server(code: error.code, message: error.message)
        }
    }
}

private struct APIEnvelope<T: Decodable>: Decodable {
    let data: T?
    let error: APIErrorBody?
}

private struct APIErrorBody: Decodable {
    let code: String
    let message: String
}

private struct EmptyResponse: Decodable {}

private struct UploadURLRequest: Encodable {
    let filename: String
    let contentType: String
    let sizeBytes: Int

    enum CodingKeys: String, CodingKey {
        case filename
        case contentType = "content_type"
        case sizeBytes = "size_bytes"
    }
}

private struct CompleteUploadRequest: Encodable {
    let objectKey: String
    let sizeBytes: Int
    let contentType: String
    let pixelWidth: Int
    let pixelHeight: Int

    enum CodingKeys: String, CodingKey {
        case objectKey = "object_key"
        case sizeBytes = "size_bytes"
        case contentType = "content_type"
        case pixelWidth = "pixel_width"
        case pixelHeight = "pixel_height"
    }
}

private struct ImageAnalysisJobRequest: Encodable {
    let assetID: UUID

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
    }
}

private struct BackendGenerationRequest: Encodable {
    let prompt: String
    let templateID: UUID
    let visualDNA: VisualDNA?
    let preservation: PreservationSettings
    let referenceAssetID: UUID?
    let generationSettings: GenerationSettings

    enum CodingKeys: String, CodingKey {
        case prompt
        case templateID = "template_id"
        case visualDNA = "visual_dna"
        case preservation
        case referenceAssetID = "reference_asset_id"
        case generationSettings = "generation_settings"
    }
}

private struct BackendStyleRequest: Encodable {
    let name: String
    let visualDNA: VisualDNA
    let previewAssetID: UUID?

    enum CodingKeys: String, CodingKey {
        case name
        case visualDNA = "visual_dna"
        case previewAssetID = "preview_asset_id"
    }
}

private struct BackendTemplate: Decodable {
    let id: UUID
    let slug: String
    let name: String
    let description: String
    let category: String
    let promptDirectives: [String]?
    let defaultSettings: GenerationSettings?
    let recommendedAspectRatio: String?
    let thumbnailURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case slug
        case name
        case description
        case category
        case promptDirectives = "prompt_directives"
        case defaultSettings = "default_settings"
        case recommendedAspectRatio = "recommended_aspect_ratio"
        case thumbnailURL = "thumbnailUrl"
    }

    var localTemplate: Template {
        let localID = slug.isEmpty ? id.uuidString : slug
        let catalogTemplate = Template.catalog.first { $0.id == localID }
        return Template(
            id: localID,
            backendID: id,
            name: name,
            description: description,
            category: localCategory,
            thumbnail: catalogTemplate?.thumbnail ?? "sparkles",
            promptInstructions: promptDirectives?.joined(separator: ", ") ?? "",
            recommendedAspectRatio: AspectRatio(
                rawValue: defaultSettings?.aspectRatio.rawValue ?? recommendedAspectRatio ?? "1:1"
            ) ?? .square,
            generationSettings: defaultSettings,
            styles: catalogTemplate?.styles ?? [],
            scenes: catalogTemplate?.scenes ?? [],
            sourceURL: catalogTemplate.flatMap(\.sourceURL),
            thumbnailURL: remoteThumbnailURL ?? catalogTemplate.flatMap(\.thumbnailURL),
            previewImageName: catalogTemplate.flatMap(\.previewImageName)
        )
    }

    private var remoteThumbnailURL: URL? {
        guard let thumbnailURL,
              let url = URL(string: thumbnailURL),
              let scheme = url.scheme?.lowercased(),
              ["http", "https"].contains(scheme) else {
            return nil
        }
        return url
    }

    private var localCategory: TemplateCategory {
        switch category.lowercased() {
        case "architecture", "architecture & spaces", "spaces":
            return .architectureSpaces
        case "brand", "brand & logos", "logos":
            return .brandLogos
        case "characters", "characters & people", "people", "portrait", "fashion":
            return .charactersPeople
        case "charts", "charts & infographics", "infographics":
            return .chartsInfographics
        case "documents", "documents & publishing", "publishing":
            return .documentsPublishing
        case "history", "history & classical themes", "classical":
            return .historyClassicalThemes
        case "illustration", "illustration & art", "art", "anime", "3d":
            return .illustrationArt
        case "photography", "photography & realism", "realism":
            return .photographyRealism
        case "posters", "posters & typography", "typography", "editorial", "social", "minimal":
            return .postersTypography
        case "product", "products", "products & e-commerce", "e-commerce":
            return .productsEcommerce
        case "scenes", "scenes & storytelling", "storytelling", "travel", "cinematic":
            return .scenesStorytelling
        case "ui", "ui & interfaces", "interfaces":
            return .uiInterfaces
        default:
            return .otherUseCases
        }
    }
}

private struct BackendJobResponse: Decodable {
    let id: UUID?
    let jobID: UUID?
    let status: JobStatus
    let result: BackendAnalysisResult?
    let output: BackendJobOutput?
    let errorCode: String?
    let errorMessage: String?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case jobID = "job_id"
        case status
        case result
        case output
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case errorCodeCamel = "errorCode"
        case errorMessageCamel = "errorMessage"
        case createdAtCamel = "createdAt"
        case updatedAtCamel = "updatedAt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id)
        jobID = try container.decodeIfPresent(UUID.self, forKey: .jobID)
        status = try container.decode(JobStatus.self, forKey: .status)
        result = try container.decodeIfPresent(BackendAnalysisResult.self, forKey: .result)
        output = try container.decodeIfPresent(BackendJobOutput.self, forKey: .output)
        errorCode = try container.decodeIfPresent(String.self, forKey: .errorCode)
            ?? container.decodeIfPresent(String.self, forKey: .errorCodeCamel)
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
            ?? container.decodeIfPresent(String.self, forKey: .errorMessageCamel)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
            ?? container.decodeIfPresent(Date.self, forKey: .createdAtCamel)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
            ?? container.decodeIfPresent(Date.self, forKey: .updatedAtCamel)
    }
}

private struct BackendAnalysisResult: Decodable {
    let visualDNA: VisualDNA?

    enum CodingKeys: String, CodingKey {
        case visualDNA = "visual_dna"
    }
}

private struct BackendJobOutput: Decodable {
    let creationID: String?

    enum CodingKeys: String, CodingKey {
        case creationID = "creationId"
        case creationIDSNAKE = "creation_id"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        creationID = try container.decodeIfPresent(String.self, forKey: .creationID)
            ?? container.decodeIfPresent(String.self, forKey: .creationIDSNAKE)
    }
}

private struct BackendStyle: Decodable {
    let id: UUID
    let name: String
    let visualDNA: VisualDNA
    let previewImageURL: URL?
    let createdAt: Date
    let previewAssetID: UUID?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case visualDNA = "visual_dna"
        case previewImageURL = "preview_image_url"
        case previewAssetID = "preview_asset_id"
        case createdAt = "created_at"
    }

    var localStyle: SavedStyle {
        SavedStyle(
            id: id,
            name: name,
            previewImage: nil,
            previewImageURL: previewImageURL,
            previewAssetID: previewAssetID,
            dna: visualDNA,
            createdAt: createdAt
        )
    }
}

private struct BackendCreationPage: Decodable {
    let items: [BackendCreation]
    let nextCursor: String?
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case items
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
    }
}

private struct BackendCreation: Decodable {
    let id: UUID
    let imageAssetID: UUID?
    let thumbnailAssetID: UUID?
    let imageURL: URL?
    let thumbnailURL: URL?
    let prompt: String
    let template: BackendTemplateSummary
    let status: CreationStatus
    let createdAt: Date
    let visualDNA: VisualDNA?
    let preservation: PreservationSettings?
    let generationSettings: GenerationSettings?
    let referenceAssetID: UUID?
    let failureMessage: String?
    let originalPrompt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case imageAssetID = "image_asset_id"
        case thumbnailAssetID = "thumbnail_asset_id"
        case imageURL = "image_url"
        case thumbnailURL = "thumbnail_url"
        case prompt
        case template
        case status
        case createdAt = "created_at"
        case visualDNA = "visual_dna"
        case preservation = "preservation_settings"
        case generationSettings = "generation_settings"
        case referenceAssetID = "reference_asset_id"
        case failureMessage = "failure_message"
        case originalPrompt = "original_prompt"
    }

    var localCreation: Creation {
        let template = Template(
            id: template.id.uuidString,
            backendID: template.id,
            name: template.name,
            description: "",
            category: .postersTypography,
            thumbnail: "sparkles",
            promptInstructions: "",
            recommendedAspectRatio: .square,
            generationSettings: nil
        )
        var draft = GenerationDraft()
        draft.prompt = originalPrompt ?? prompt
        draft.referenceAssetID = referenceAssetID
        draft.visualDNA = visualDNA
        draft.preservation = preservation ?? .defaultSelection
        draft.selectedTemplate = template
        draft.settings = generationSettings ?? GenerationSettings()
        draft.selectedStyle = visualDNA == nil
            ? .none
            : (referenceAssetID == nil
                ? .savedStyle(SavedStyle(name: "\(template.name) Direction", dna: visualDNA!))
                : .fromReference)
        let generationRequest = ImageGenerationRequest(draft: draft)
        return Creation(
            id: id,
            generatedAssetID: imageAssetID,
            thumbnailAssetID: thumbnailAssetID,
            generatedImageURL: imageURL,
            thumbnailURL: thumbnailURL,
            prompt: originalPrompt ?? prompt,
            template: template,
            visualDNA: visualDNA,
            preservation: preservation ?? .defaultSelection,
            referenceImage: nil,
            settings: generationSettings ?? GenerationSettings(),
            palette: ["indigo", "olive", "ink"],
            createdAt: createdAt,
            status: status,
            failureMessage: failureMessage,
            generationRequest: generationRequest
        )
    }
}

private struct BackendCreationSummary: Decodable {}

private struct BackendTemplateSummary: Decodable {
    let id: UUID
    let name: String
}
