import SwiftUI
import Observation

@Observable
final class AppState {
    // MARK: - Recording State
    var isRecording = false
    var isProcessing = false

    // MARK: - Results
    var lastTranscription: String?
    var lastInstruction: NvimInstruction?
    var errorMessage: String?

    // MARK: - Permissions
    var hasScreenCapturePermission = false
    var hasMicrophonePermission = false
    var hasAccessibilityPermission = false

    var allPermissionsGranted: Bool {
        hasScreenCapturePermission && hasMicrophonePermission && hasAccessibilityPermission
    }

    // MARK: - Settings
    var whisperModel: String {
        get { UserDefaults.standard.string(forKey: "whisperModel") ?? "base" }
        set { UserDefaults.standard.set(newValue, forKey: "whisperModel") }
    }

    var overlayDuration: TimeInterval {
        get { UserDefaults.standard.double(forKey: "overlayDuration").nonZero ?? 8.0 }
        set { UserDefaults.standard.set(newValue, forKey: "overlayDuration") }
    }

    var imageDetail: String {
        get { UserDefaults.standard.string(forKey: "imageDetail") ?? "low" }
        set { UserDefaults.standard.set(newValue, forKey: "imageDetail") }
    }

    var statusText: String {
        if isProcessing { return "Processing..." }
        if isRecording { return "Listening..." }
        return "Ready"
    }

    var menuBarIcon: String {
        if isRecording { return "mic.fill" }
        if isProcessing { return "brain.head.profile" }
        return "mic"
    }
}

private extension Double {
    var nonZero: Double? {
        self == 0 ? nil : self
    }
}
