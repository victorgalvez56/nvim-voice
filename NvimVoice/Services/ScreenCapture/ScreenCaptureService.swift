import ScreenCaptureKit
import CoreGraphics
import CoreImage

actor ScreenCaptureService {
    private var stream: SCStream?
    private var streamOutput: StreamOutput?

    func captureFrame() async throws -> CGImage {
        let content = try await SCShareableContent.current
        guard let display = content.displays.first else {
            throw ScreenCaptureError.noDisplay
        }

        let filter = SCContentFilter(display: display, excludingWindows: [])

        let config = SCStreamConfiguration()
        config.width = display.width / 2
        config.height = display.height / 2
        config.minimumFrameInterval = CMTime(value: 1, timescale: 1)
        config.pixelFormat = kCVPixelFormatType_32BGRA
        config.queueDepth = 1

        let output = StreamOutput()
        self.streamOutput = output

        let stream = SCStream(filter: filter, configuration: config, delegate: nil)
        try stream.addStreamOutput(output, type: .screen, sampleHandlerQueue: .global(qos: .userInitiated))

        try await stream.startCapture()

        let image = try await output.waitForFrame(timeout: 3.0)

        try await stream.stopCapture()
        self.stream = nil
        self.streamOutput = nil

        return image
    }
}

enum ScreenCaptureError: LocalizedError {
    case noDisplay
    case noFrame
    case timeout

    var errorDescription: String? {
        switch self {
        case .noDisplay: return "No display found for screen capture"
        case .noFrame: return "Failed to capture screen frame"
        case .timeout: return "Screen capture timed out"
        }
    }
}

private final class StreamOutput: NSObject, SCStreamOutput, @unchecked Sendable {
    private var continuation: CheckedContinuation<CGImage, Error>?
    private let lock = NSLock()
    private let ciContext = CIContext()

    func waitForFrame(timeout: TimeInterval) async throws -> CGImage {
        try await withCheckedThrowingContinuation { continuation in
            lock.lock()
            self.continuation = continuation
            lock.unlock()

            DispatchQueue.global().asyncAfter(deadline: .now() + timeout) { [weak self] in
                self?.lock.lock()
                if let cont = self?.continuation {
                    self?.continuation = nil
                    self?.lock.unlock()
                    cont.resume(throwing: ScreenCaptureError.timeout)
                } else {
                    self?.lock.unlock()
                }
            }
        }
    }

    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen else { return }
        guard let imageBuffer = sampleBuffer.imageBuffer else { return }

        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return }

        lock.lock()
        if let cont = continuation {
            continuation = nil
            lock.unlock()
            cont.resume(returning: cgImage)
        } else {
            lock.unlock()
        }
    }
}
