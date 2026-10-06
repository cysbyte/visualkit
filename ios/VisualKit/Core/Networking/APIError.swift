import Foundation

enum APIError: LocalizedError {
    case networkUnavailable
    case invalidRequest(String)
    case insufficientCredits
    case analysisFailed(String)
    case generationFailed(String)
    case uploadFailed(String)
    case authenticationRequired
    case unauthorized
    case notFound
    case unavailable
    case invalidResponse
    case server(code: String, message: String)
    case timedOut
    case cancelled

    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "The network is unavailable. Check your connection and try again."
        case .invalidRequest(let message):
            return message
        case .insufficientCredits:
            return "There are not enough credits for this generation."
        case .analysisFailed:
            return "The reference image could not be analyzed. Try again."
        case .generationFailed:
            return "The image could not be generated. Try again."
        case .uploadFailed:
            return "The image could not be uploaded. Try again."
        case .authenticationRequired, .unauthorized:
            return "Sign in is required to continue."
        case .notFound:
            return "That VisualKit resource is no longer available."
        case .unavailable:
            return "The VisualKit service is unavailable."
        case .invalidResponse:
            return "The service returned an invalid response."
        case .server:
            return "VisualKit could not complete that request."
        case .timedOut:
            return "The request took too long. Try again."
        case .cancelled:
            return "The operation was cancelled."
        }
    }

    static func map(_ error: Error, operation: APIErrorOperation) -> APIError {
        if let error = error as? APIError {
            return error
        }
        if error is CancellationError {
            return .cancelled
        }
        if let urlError = error as? URLError {
            switch urlError.code {
            case .cancelled:
                return .cancelled
            case .notConnectedToInternet, .networkConnectionLost, .cannotFindHost,
                 .cannotConnectToHost, .dnsLookupFailed, .timedOut:
                return urlError.code == .timedOut ? .timedOut : .networkUnavailable
            default:
                break
            }
        }
        return .server(
            code: operation.rawValue,
            message: error.localizedDescription
        )
    }
}

enum APIErrorOperation: String {
    case request
    case upload
    case analysis
    case generation
}
