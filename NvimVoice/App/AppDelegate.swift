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

    init(appState: AppState) {
        self.appState = appState
        super.init()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        checkPermissions()
        setupHotkey()
        Task { await loadWhisperModel() }
    }

    // MARK: - Permissions

    private func checkPermissions() {
        appState.hasScreenCapturePermission = ScreenCapturePermission.hasPermission()
        appState.hasAccessibilityPermission = AccessibilityPermission.hasPermission()

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.checkPermissions()
        }
    }

    // MARK: - Hotkey

    private func setupHotkey() {
        hotkeyService.onToggle = { [weak self] in
            Task { @MainActor in
                self?.handleHotkeyToggle()
            }
        }
        hotkeyService.start()
    }

    private func handleHotkeyToggle() {
        if appState.isRecording {
            stopAndProcess()
        } else {
            startRecording()
        }
    }

    // MARK: - Recording Flow

    private func startRecording() {
        guard !appState.isProcessing else { return }
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

        Task {
            do {
                let instruction = try await processVoiceCommand()
                appState.lastInstruction = instruction
                appState.isProcessing = false
                overlayController.showInstruction(instruction, duration: appState.overlayDuration)
            } catch {
                appState.errorMessage = error.localizedDescription
                appState.isProcessing = false
                overlayController.dismiss()
            }
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
            keybindings: keybindingsMarkdown
        )

        let instruction = try await openAIService.analyzeScreenWithVoice(
            base64Image: base64Image,
            prompt: prompt,
            detail: appState.imageDetail
        )

        return instruction
    }

    // MARK: - Whisper Model

    private func loadWhisperModel() async {
        do {
            try await whisperService.loadModel(name: appState.whisperModel)
        } catch {
            appState.errorMessage = "Failed to load Whisper model: \(error.localizedDescription)"
        }
    }
}
