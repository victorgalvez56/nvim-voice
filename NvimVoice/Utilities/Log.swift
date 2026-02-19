import Foundation
import os

enum Log {
    private static let logger = Logger(subsystem: "com.victorgalvez.NvimVoice", category: "app")
    private static let logFile: URL = {
        let dir = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".config/nvimvoice")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("debug.log")
    }()

    static func info(_ message: String) {
        let line = "[\(timestamp)] \(message)"
        logger.info("\(line)")
        appendToFile(line)
    }

    static func error(_ message: String) {
        let line = "[\(timestamp)] ERROR: \(message)"
        logger.error("\(line)")
        appendToFile(line)
    }

    private static var timestamp: String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f.string(from: Date())
    }

    private static func appendToFile(_ line: String) {
        let data = (line + "\n").data(using: .utf8) ?? Data()
        if FileManager.default.fileExists(atPath: logFile.path) {
            if let handle = try? FileHandle(forWritingTo: logFile) {
                handle.seekToEndOfFile()
                handle.write(data)
                handle.closeFile()
            }
        } else {
            try? data.write(to: logFile)
        }
    }
}
