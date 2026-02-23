import AppKit
import CoreGraphics
import UniformTypeIdentifiers

enum ImageUtils {
    static func cgImageToBase64JPEG(_ image: CGImage, quality: CGFloat = 0.6) throws -> String {
        let bitmapRep = NSBitmapImageRep(cgImage: image)
        guard let jpegData = bitmapRep.representation(
            using: .jpeg,
            properties: [.compressionFactor: quality]
        ) else {
            throw ImageError.jpegEncodingFailed
        }
        return jpegData.base64EncodedString()
    }
}

enum ImageError: LocalizedError {
    case jpegEncodingFailed

    var errorDescription: String? {
        switch self {
        case .jpegEncodingFailed: return "Failed to encode image as JPEG"
        }
    }
}
