import AppKit
import SwiftUI

@MainActor
final class AppDelegate: NSObject {
    private let appState: AppState
    private let screenCaptureService = ScreenCaptureService()
    private let audioCaptureService = AudioCaptureService()
    private let whisperService = WhisperService()
    private let openAIService = OpenAIService()
    private let hotkeyService = HotkeyService()
    private let overlayController = OverlayController()
    private let keybindingContext = KeybindingContext()
    private let keymappService = KeymappService()
    private var processingTask: Task<Void, Never>?

    init(appState: AppState) {
        self.appState = appState
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        Log.info("App launched")
        checkPermissions()
        setupHotkey()
        loadKeyboardLayout()
        Task { await loadWhisperModel() }
    }

    // MARK: - Permissions

    func checkPermissions() {
        appState.hasScreenCapturePermission = ScreenCapturePermission.hasPermission()
        appState.hasAccessibilityPermission = AccessibilityPermission.hasPermission()
        appState.isHotkeyActive = hotkeyService.isActive
        Log.info("Permissions — screen:\(appState.hasScreenCapturePermission) mic:\(appState.hasMicrophonePermission) ax:\(appState.hasAccessibilityPermission) hotkey:\(appState.isHotkeyActive)")

        Task {
            appState.hasMicrophonePermission = await AudioPermission.requestPermission()
        }
    }

    func requestAllPermissions() {
        ScreenCapturePermission.requestPermission()
        AccessibilityPermission.requestPermission()
        Task {
            appState.hasMicrophonePermission = await AudioPermission.requestPermission()
        }
        // Re-check after a delay to pick up granted permissions
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.checkPermissions()
            // Retry hotkey if accessibility was just granted
            if self?.appState.hasAccessibilityPermission == true && self?.hotkeyService.isActive == false {
                self?.hotkeyService.start()
                self?.appState.isHotkeyActive = self?.hotkeyService.isActive ?? false
            }
        }
    }

    func openSystemPreferences(_ anchor: String) {
        let url: URL
        switch anchor {
        case "accessibility":
            url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        case "screenRecording":
            url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")!
        case "microphone":
            url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone")!
        default:
            url = URL(string: "x-apple.systempreferences:com.apple.preference.security")!
        }
        NSWorkspace.shared.open(url)
    }

    // MARK: - Hotkey

    private func setupHotkey() {
        hotkeyService.onToggle = { [weak self] in
            Task { @MainActor in
                self?.toggleRecording()
            }
        }
        hotkeyService.onCancel = { [weak self] in
            Task { @MainActor in
                self?.cancelRecording()
            }
        }
        hotkeyService.start()
        appState.isHotkeyActive = hotkeyService.isActive
    }

    func toggleRecording() {
        if appState.isRecording {
            stopAndProcess()
        } else {
            startRecording()
        }
    }

    func cancelRecording() {
        guard appState.isRecording || appState.isProcessing else { return }
        Log.info("Recording cancelled")

        if appState.isRecording {
            _ = audioCaptureService.stopRecording() // discard audio
        }

        processingTask?.cancel()
        processingTask = nil
        appState.isRecording = false
        appState.isProcessing = false
        appState.errorMessage = nil
        overlayController.dismiss()
    }

    // MARK: - Recording Flow

    private func startRecording() {
        guard !appState.isProcessing else { return }

        guard appState.allPermissionsGranted else {
            appState.errorMessage = "Missing permissions: \(appState.missingPermissions.joined(separator: ", "))"
            return
        }

        guard appState.isWhisperReady else {
            appState.errorMessage = "Whisper model still loading..."
            return
        }

        guard KeychainHelper.loadAPIKey() != nil else {
            appState.errorMessage = "OpenAI API key not set. Open Settings to add it."
            return
        }

        appState.errorMessage = nil
        appState.lastInstruction = nil

        do {
            try audioCaptureService.startRecording()
            appState.isRecording = true
        } catch {
            appState.errorMessage = "Failed to start recording: \(error.localizedDescription)"
        }
    }

    private func stopAndProcess() {
        appState.isRecording = false
        appState.isProcessing = true
        overlayController.showProcessing()

        processingTask = Task {
            do {
                let instruction = try await processVoiceCommand()
                guard !Task.isCancelled else { return }
                appState.lastInstruction = instruction
                appState.isProcessing = false
                overlayController.showInstruction(instruction, duration: appState.overlayDuration)
            } catch {
                guard !Task.isCancelled else { return }
                appState.errorMessage = error.localizedDescription
                appState.isProcessing = false
                overlayController.dismiss()
            }
            processingTask = nil
        }
    }

    private func processVoiceCommand() async throws -> NvimInstruction {
        let audioData = audioCaptureService.stopRecording()

        async let transcriptionTask = whisperService.transcribe(audioData: audioData)
        async let frameTask = screenCaptureService.captureFrame()

        let transcription = try await transcriptionTask
        let frame = try await frameTask

        appState.lastTranscription = transcription

        let base64Image = ImageUtils.cgImageToBase64JPEG(frame, quality: 0.6)
        let keybindingsMarkdown = keybindingContext.generateContext()

        let prompt = PromptBuilder.buildPrompt(
            transcription: transcription,
            keybindings: keybindingsMarkdown,
            hasKeyboard: appState.keyboardGeometry != nil
        )

        let instruction = try await openAIService.analyzeScreenWithVoice(
            base64Image: base64Image,
            prompt: prompt,
            detail: appState.imageDetail
        )

        return instruction
    }

    // MARK: - Keyboard Layout

    private func loadKeyboardLayout() {
        guard let layout = keymappService.loadLayout() else {
            Log.info("No keyboard layout loaded")
            return
        }
        keybindingContext.keyboardLayout = layout
        appState.keyboardName = layout.title
        appState.keyboardGeometry = layout.geometry.displayName
        appState.keyboardLayerCount = layout.layers.count
        appState.keyboardLayout = layout
        overlayController.keyboardLayout = layout
    }

    // MARK: - Whisper Model

    private func loadWhisperModel() async {
        do {
            try await whisperService.loadModel(name: appState.whisperModel)
            appState.isWhisperReady = true
        } catch {
            appState.errorMessage = "Failed to load Whisper model: \(error.localizedDescription)"
        }
    }
}
