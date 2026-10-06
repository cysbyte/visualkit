import Foundation
import ImageIO
import UIKit

enum MockGeneratedImageFactory {
    static func makeSelectedImage(for result: GenerationResult) -> SelectedImage? {
        makeSelectedImage(
            for: result.request,
            creationID: result.creation.id,
            palette: result.creation.palette
        )
    }

    static func makeSelectedImage(
        for request: ImageGenerationRequest,
        creationID: UUID,
        palette: [String]
    ) -> SelectedImage? {
        let size = pixelSize(for: request.settings.aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let colors = palette.map(color(for:))
            let gradientColors = colors.map(\.cgColor) as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()

            guard let gradient = CGGradient(
                colorsSpace: colorSpace,
                colors: gradientColors,
                locations: nil
            ) else {
                UIColor.systemGray.setFill()
                context.fill(CGRect(origin: .zero, size: size))
                return
            }

            context.cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )

            UIColor.white.withAlphaComponent(0.16).setFill()
            context.cgContext.fillEllipse(
                in: CGRect(
                    x: size.width * 0.54,
                    y: -size.height * 0.08,
                    width: size.width * 0.56,
                    height: size.width * 0.56
                )
            )

            UIColor.black.withAlphaComponent(0.14).setFill()
            context.cgContext.saveGState()
            context.cgContext.translateBy(
                x: size.width * 0.18,
                y: size.height * 0.66
            )
            context.cgContext.rotate(by: -0.18)
            context.cgContext.fill(
                CGRect(
                    x: -size.width * 0.06,
                    y: -size.height * 0.10,
                    width: size.width * 0.62,
                    height: size.height * 0.24
                )
            )
            context.cgContext.restoreGState()
        }

        guard let data = image.jpegData(compressionQuality: 0.88) else {
            return nil
        }

        return SelectedImage(
            data: data,
            filename: "visualkit-generated-\(creationID.uuidString).jpg",
            mimeType: "image/jpeg",
            sourceTypeIdentifier: "com.visualkit.generated",
            pixelWidth: Int(size.width),
            pixelHeight: Int(size.height),
            originalByteCount: data.count,
            byteCount: data.count
        )
    }

    static func thumbnailData(
        for image: SelectedImage,
        maximumPixelDimension: Int = 720
    ) -> Data? {
        guard let source = CGImageSourceCreateWithData(image.data as CFData, nil) else {
            return image.data
        }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maximumPixelDimension
        ]

        guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(
            source,
            0,
            options as CFDictionary
        ) else {
            return image.data
        }

        return UIImage(cgImage: thumbnail).jpegData(compressionQuality: 0.78)
    }

    private static func color(for token: String) -> UIColor {
        switch token {
        case "coral":
            return UIColor(red: 0.94, green: 0.39, blue: 0.28, alpha: 1)
        case "mint":
            return UIColor(red: 0.58, green: 0.78, blue: 0.69, alpha: 1)
        case "lavender":
            return UIColor(red: 0.68, green: 0.62, blue: 0.86, alpha: 1)
        case "indigo":
            return UIColor(red: 0.25, green: 0.28, blue: 0.52, alpha: 1)
        case "olive":
            return UIColor(red: 0.48, green: 0.52, blue: 0.31, alpha: 1)
        case "cream":
            return UIColor(red: 0.92, green: 0.82, blue: 0.63, alpha: 1)
        default:
            return UIColor(red: 0.09, green: 0.10, blue: 0.12, alpha: 1)
        }
    }

    private static func pixelSize(for aspectRatio: AspectRatio) -> CGSize {
        switch aspectRatio {
        case .square:
            return CGSize(width: 1200, height: 1200)
        case .portrait:
            return CGSize(width: 1200, height: 1500)
        case .story:
            return CGSize(width: 1080, height: 1920)
        case .landscape:
            return CGSize(width: 1600, height: 900)
        }
    }
}
