import Foundation

protocol ImageAPI: Sendable {
    func requestUploadURL(
        filename: String,
        contentType: String,
        sizeBytes: Int
    ) async throws -> AssetUploadAuthorization
    func completeUpload(
        assetID: UUID,
        objectKey: String,
        sizeBytes: Int,
        contentType: String,
        pixelWidth: Int,
        pixelHeight: Int
    ) async throws -> AssetRecord
    func downloadURL(for assetID: UUID) async throws -> SignedAssetURL
}

protocol AnalysisAPI: Sendable {
    func analyzeImage(assetID: UUID) async throws -> JobReference
}

protocol GenerationAPI: Sendable {
    func generateImage(
        request: ImageGenerationRequest,
        idempotencyKey: UUID
    ) async throws -> JobReference
}

protocol JobAPI: AnalysisAPI, GenerationAPI, Sendable {
    func getJobStatus<Result: Codable & Hashable & Sendable>(
        jobID: String,
        kind: JobKind
    ) async throws -> Job<Result>
    func cancel(jobID: String) async throws
}

protocol StylesAPI: Sendable {
    func listStyles() async throws -> [SavedStyle]
    func getStyle(id: UUID) async throws -> SavedStyle
    func createStyle(_ style: SavedStyle) async throws -> SavedStyle
    func updateStyle(_ style: SavedStyle) async throws -> SavedStyle
    func deleteStyle(id: UUID) async throws
}

protocol CreationsAPI: Sendable {
    func listCreations(limit: Int, cursor: String?) async throws -> CreationPage
    func getCreation(id: UUID) async throws -> Creation
    func deleteCreation(id: UUID) async throws
}

protocol TemplatesAPI: Sendable {
    func listTemplates() async throws -> [Template]
}

protocol CreditsAPI: Sendable {
    func getBalance() async throws -> CreditBalance
    func estimate(templateID: UUID, aspectRatio: AspectRatio) async throws -> CreditEstimate
}

protocol BackendAPIClient: ImageAPI, AnalysisAPI, GenerationAPI, JobAPI, StylesAPI, CreationsAPI, TemplatesAPI, CreditsAPI, Sendable {
    func analyzeReference(_ request: ImageAnalysisRequest) async throws -> VisualDNA
    func generateImage(from request: ImageGenerationRequest) async throws -> Creation
}

struct APIConfiguration: Sendable {
    let baseURL: URL
    let bearerToken: String?
    let developmentUserID: UUID?
    let requestTimeout: TimeInterval
    let retryPolicy: APIRetryPolicy

    static func fromEnvironment(
        processInfo: ProcessInfo = .processInfo,
        bundle: Bundle = .main
    ) -> APIConfiguration? {
        let values = processInfo.environment
        let rawBaseURL = values["VISUALYZE_API_BASE_URL"]
            ?? bundle.object(forInfoDictionaryKey: "APIBaseURL") as? String
        guard let rawBaseURL,
              let baseURL = URL(string: rawBaseURL),
              baseURL.scheme != nil,
              baseURL.host != nil else {
            return nil
        }

        let bearerToken = values["VISUALYZE_API_TOKEN"]
            ?? bundle.object(forInfoDictionaryKey: "APIBearerToken") as? String
        let developmentUserID = (values["VISUALYZE_DEVELOPMENT_USER_ID"]
            ?? bundle.object(forInfoDictionaryKey: "APIDevelopmentUserID") as? String)
            .flatMap(UUID.init(uuidString:))
        let timeout = values["VISUALYZE_API_TIMEOUT_SECONDS"]
            .flatMap(TimeInterval.init)
            ?? 30
        let retryAttempts = values["VISUALYZE_API_RETRY_ATTEMPTS"]
            .flatMap(Int.init)
            ?? APIRetryPolicy.production.maxAttempts

        return APIConfiguration(
            baseURL: baseURL,
            bearerToken: bearerToken,
            developmentUserID: developmentUserID,
            requestTimeout: timeout,
            retryPolicy: APIRetryPolicy(maxAttempts: retryAttempts)
        )
    }

    init(
        baseURL: URL,
        bearerToken: String? = nil,
        developmentUserID: UUID? = nil,
        requestTimeout: TimeInterval = 30,
        retryPolicy: APIRetryPolicy = .production
    ) {
        self.baseURL = baseURL
        self.bearerToken = bearerToken
        self.developmentUserID = developmentUserID
        self.requestTimeout = requestTimeout
        self.retryPolicy = retryPolicy
    }
}

struct APIRetryPolicy: Hashable, Sendable {
    let maxAttempts: Int
    let baseDelay: TimeInterval
    let maxDelay: TimeInterval

    static let production = APIRetryPolicy()

    init(
        maxAttempts: Int = 3,
        baseDelay: TimeInterval = 0.35,
        maxDelay: TimeInterval = 3
    ) {
        self.maxAttempts = max(1, maxAttempts)
        self.baseDelay = max(0.1, baseDelay)
        self.maxDelay = max(self.baseDelay, maxDelay)
    }
}

struct AssetUploadAuthorization: Codable, Hashable, Sendable {
    let assetID: UUID
    let uploadURL: URL
    let objectKey: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case uploadURL = "upload_url"
        case objectKey = "object_key"
        case expiresIn = "expires_in"
    }
}

struct AssetRecord: Codable, Hashable, Sendable {
    let id: UUID
    let status: String
    let objectKey: String

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case objectKey = "object_key"
        case objectKeyCamel = "objectKey"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        status = try container.decode(String.self, forKey: .status)
        objectKey = try container.decodeIfPresent(String.self, forKey: .objectKey)
            ?? container.decodeIfPresent(String.self, forKey: .objectKeyCamel)
            ?? ""
    }

    init(id: UUID, status: String, objectKey: String) {
        self.id = id
        self.status = status
        self.objectKey = objectKey
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(status, forKey: .status)
        try container.encode(objectKey, forKey: .objectKey)
    }
}

struct SignedAssetURL: Codable, Hashable, Sendable {
    let assetID: UUID
    let downloadURL: URL
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case assetID = "asset_id"
        case downloadURL = "download_url"
        case expiresIn = "expires_in"
    }
}

struct CreditBalance: Codable, Hashable, Sendable {
    let balance: Int
}

struct CreditEstimate: Codable, Hashable, Sendable {
    let estimatedCredits: Int

    enum CodingKeys: String, CodingKey {
        case estimatedCredits = "estimated_credits"
    }
}

struct CreationPage: Codable, Hashable, Sendable {
    let items: [Creation]
    let nextCursor: String?
    let hasMore: Bool

    enum CodingKeys: String, CodingKey {
        case items
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
    }
}

struct MockBackendAPIClient: BackendAPIClient {
    func requestUploadURL(filename: String, contentType: String, sizeBytes: Int) async throws -> AssetUploadAuthorization {
        AssetUploadAuthorization(
            assetID: UUID(),
            uploadURL: URL(string: "https://mock.visualkit/upload")!,
            objectKey: "mock/\(UUID().uuidString)",
            expiresIn: 900
        )
    }

    func completeUpload(assetID: UUID, objectKey: String, sizeBytes: Int, contentType: String, pixelWidth: Int, pixelHeight: Int) async throws -> AssetRecord {
        AssetRecord(id: assetID, status: "ready", objectKey: objectKey)
    }

    func downloadURL(for assetID: UUID) async throws -> SignedAssetURL {
        SignedAssetURL(
            assetID: assetID,
            downloadURL: URL(string: "https://mock.visualkit/assets/\(assetID)")!,
            expiresIn: 900
        )
    }

    func analyzeImage(assetID: UUID) async throws -> JobReference {
        JobReference(id: UUID().uuidString, kind: .imageAnalysis)
    }

    func generateImage(request: ImageGenerationRequest, idempotencyKey: UUID) async throws -> JobReference {
        JobReference(id: UUID().uuidString, kind: .imageGeneration)
    }

    func getJobStatus<Result: Codable & Hashable & Sendable>(
        jobID: String,
        kind: JobKind
    ) async throws -> Job<Result> {
        Job(id: jobID, kind: kind, status: .completed)
    }

    func cancel(jobID: String) async throws {}

    func listStyles() async throws -> [SavedStyle] { SavedStyle.samples }
    func getStyle(id: UUID) async throws -> SavedStyle { SavedStyle.samples.first(where: { $0.id == id }) ?? SavedStyle.samples[0] }
    func createStyle(_ style: SavedStyle) async throws -> SavedStyle { style }
    func updateStyle(_ style: SavedStyle) async throws -> SavedStyle { style }
    func deleteStyle(id: UUID) async throws {}
    func listCreations(limit: Int, cursor: String?) async throws -> CreationPage {
        CreationPage(items: Creation.samples, nextCursor: nil, hasMore: false)
    }
    func getCreation(id: UUID) async throws -> Creation {
        Creation.samples.first(where: { $0.id == id }) ?? Creation.samples[0]
    }
    func deleteCreation(id: UUID) async throws {}
    func listTemplates() async throws -> [Template] { Template.catalog }
    func getBalance() async throws -> CreditBalance { CreditBalance(balance: 0) }
    func estimate(templateID: UUID, aspectRatio: AspectRatio) async throws -> CreditEstimate { CreditEstimate(estimatedCredits: 80) }

    func analyzeReference(_ request: ImageAnalysisRequest) async throws -> VisualDNA {
        try await Task.sleep(for: .milliseconds(500))
        return .sample
    }

    func generateImage(from request: ImageGenerationRequest) async throws -> Creation {
        try await Task.sleep(for: .milliseconds(900))
        let id = UUID()
        let palette = request.visualDNA?.palette ?? ["indigo", "olive", "ink"]
        let image = MockGeneratedImageFactory.makeSelectedImage(
            for: request,
            creationID: id,
            palette: palette
        )
        return Creation(
            id: id,
            generatedImage: image,
            thumbnailData: image.flatMap { MockGeneratedImageFactory.thumbnailData(for: $0) },
            prompt: request.userPrompt,
            template: request.template,
            visualDNA: request.visualDNA,
            preservation: request.preservation,
            referenceImage: request.referenceImage,
            settings: request.settings,
            palette: palette,
            status: .completed,
            generationRequest: request
        )
    }
}
