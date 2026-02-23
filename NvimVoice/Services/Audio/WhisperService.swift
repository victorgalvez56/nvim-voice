import Foundation
import WhisperKit

actor WhisperService {
    private var whisperKit: WhisperKit?
    private var isLoading = false
    private var loadError: Error?

    func loadModel(name: String = "base") async throws {
        guard !isLoading else { return }
        isLoading = true
        loadError = nil
        defer { isLoading = false }

        do {
            let kit = try await WhisperKit(model: name)
            self.whisperKit = kit
        } catch {
            self.loadError = error
            throw error
        }
    }

    func transcribe(audioData: [Float]) async throws -> String {
        if let loadError {
            throw WhisperError.modelLoadFailed(loadError.localizedDescription)
        }
        guard let whisperKit else {
            throw WhisperError.modelNotLoaded
        }

        let results = try await whisperKit.transcribe(audioArray: audioData)
        let text = results.map(\.text).joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)

        if text.isEmpty {
            throw WhisperError.emptyTranscription
        }

        return text
    }
}

enum WhisperError: LocalizedError {
    case modelNotLoaded
    case modelLoadFailed(String)
    case emptyTranscription

    var errorDescription: String? {
        switch self {
        case .modelNotLoaded: return "Whisper model not loaded. Please wait for model download."
        case .modelLoadFailed(let reason): return "Whisper model failed to load: \(reason)"
        case .emptyTranscription: return "No speech detected in recording."
        }
    }
}
