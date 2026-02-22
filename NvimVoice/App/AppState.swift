import SwiftUI
import Observation

@Observable
final class AppState {
    // MARK: - Recording State
    var isRecording = false
    var isProcessing = false
    var isWhisperReady = false
    var isHotkeyActive = false

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

    var missingPermissions: [String] {
        var missing: [String] = []
        if !hasScreenCapturePermission { missing.append("Screen Recording") }
        if !hasMicrophonePermission { missing.append("Microphone") }
        if !hasAccessibilityPermission { missing.append("Accessibility") }
        return missing
    }

    var canRecord: Bool {
        allPermissionsGranted && isWhisperReady && !isProcessing
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

    // MARK: - Keyboard (non-persisted, loaded on launch)
    var keyboardName: String?
    var keyboardGeometry: String?
    var keyboardLayerCount: Int?
    var keyboardLayout: KeyboardLayout?
    var isKeyboardConnected: Bool = false

    var menuBarIcon: String {
        if isRecording { return "waveform.circle.fill" }
        if isProcessing { return "ellipsis.circle.fill" }
        return "chevron.left.forwardslash.chevron.right"
    }
}

private extension Double {
    var nonZero: Double? {
        self == 0 ? nil : self
    }
}
