import Foundation
import CryptoKit

/// Stores the API key in an encrypted file under ~/.config/nvimvoice/
/// Works without code signing (unlike Keychain with ad-hoc builds).
enum KeychainHelper {
    private static let configDir: URL = {
        let home = FileManager.default.homeDirectoryForCurrentUser
        return home.appendingPathComponent(".config/nvimvoice")
    }()

    private static let keyFile: URL = {
        configDir.appendingPathComponent(".api-key")
    }()

    /// Derive a machine-specific key from hardware UUID
    private static var encryptionKey: SymmetricKey {
        let seed = machineID + "com.victorgalvez.NvimVoice.salt"
        let hash = SHA256.hash(data: Data(seed.utf8))
        return SymmetricKey(data: hash)
    }

    static func saveAPIKey(_ key: String) throws {
        try FileManager.default.createDirectory(at: configDir, withIntermediateDirectories: true)

        let data = Data(key.utf8)
        let sealed = try AES.GCM.seal(data, using: encryptionKey)
        guard let combined = sealed.combined else {
            throw KeychainError.encodingFailed
        }
        try combined.write(to: keyFile)

        // Restrict file permissions: owner read/write only
        try FileManager.default.setAttributes(
            [.posixPermissions: 0o600],
            ofItemAtPath: keyFile.path
        )
    }

    static func loadAPIKey() -> String? {
        guard let combined = try? Data(contentsOf: keyFile) else { return nil }
        guard let box = try? AES.GCM.SealedBox(combined: combined) else { return nil }
        guard let data = try? AES.GCM.open(box, using: encryptionKey) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func deleteAPIKey() {
        try? FileManager.default.removeItem(at: keyFile)
    }

    private static var machineID: String {
        let service = IOServiceGetMatchingService(kIOMainPortDefault, IOServiceMatching("IOPlatformExpertDevice"))
        defer { IOObjectRelease(service) }
        guard let uuid = IORegistryEntryCreateCFProperty(
            service,
            "IOPlatformUUID" as CFString,
            kCFAllocatorDefault,
            0
        )?.takeRetainedValue() as? String else {
            return "fallback-nvimvoice-key"
        }
        return uuid
    }
}

enum KeychainError: LocalizedError {
    case encodingFailed
    case saveFailed(OSStatus)

    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return "Failed to encrypt API key"
        case .saveFailed(let status):
            return "Failed to save (status: \(status))"
        }
    }
}
