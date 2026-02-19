import AppKit
import CoreGraphics
import UniformTypeIdentifiers

enum ImageUtils {
    static func cgImageToBase64JPEG(_ image: CGImage, quality: CGFloat = 0.6) -> String {
        let bitmapRep = NSBitmapImageRep(cgImage: image)
        guard let jpegData = bitmapRep.representation(
            using: .jpeg,
            properties: [.compressionFactor: quality]
        ) else {
            return ""
        }
        return jpegData.base64EncodedString()
    }
}
