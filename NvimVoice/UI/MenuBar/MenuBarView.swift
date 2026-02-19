import SwiftUI

struct MenuBarView: View {
    let appState: AppState
    let delegate: AppDelegate

    var body: some View {
        VStack(spacing: 0) {
            // Header with record button
            recordSection
                .padding(12)

            Divider()

            // Status / Warnings
            if !appState.allPermissionsGranted {
                setupSection
                    .padding(12)
                Divider()
            } else if !appState.isWhisperReady {
                loadingModelBanner
                    .padding(12)
                Divider()
            } else if !appState.isHotkeyActive {
                hotkeyWarning
                    .padding(12)
                Divider()
            }

            // Error
            if let error = appState.errorMessage {
                errorBanner(error)
                    .padding(12)
                Divider()
            }

            // Last result
            if appState.lastInstruction != nil || appState.lastTranscription != nil {
                lastResultSection
                    .padding(12)
                Divider()
            }

            // Footer
            footerSection
                .padding(.horizontal, 4)
                .padding(.vertical, 4)
        }
        .frame(width: 300)
    }

    // MARK: - Record Section

    private var recordSection: some View {
        VStack(spacing: 10) {
            Button {
                delegate.toggleRecording()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: recordIcon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(recordIconColor)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(recordTitle)
                            .font(.system(.body, weight: .semibold))
                        Text(recordSubtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text("\u{2318}\u{21E7}V")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 4))
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .disabled(!appState.canRecord && !appState.isRecording)
            .opacity((!appState.canRecord && !appState.isRecording) ? 0.4 : 1)

            if appState.isRecording {
                recordingIndicator
                cancelButton
            }

            if appState.isProcessing {
                processingIndicator
                cancelButton
            }
        }
    }

    private var recordIcon: String {
        if appState.isProcessing { return "brain.head.profile" }
        if appState.isRecording { return "stop.circle.fill" }
        return "mic.circle.fill"
    }

    private var recordIconColor: Color {
        if appState.isRecording { return .red }
        if appState.isProcessing { return .orange }
        return .blue
    }

    private var recordTitle: String {
        if appState.isProcessing { return "Processing..." }
        if appState.isRecording { return "Stop Recording" }
        return "Start Recording"
    }

    private var recordSubtitle: String {
        if appState.isProcessing { return "Analyzing screenshot + voice" }
        if appState.isRecording { return "Listening... speak your command" }
        return "Ask a Neovim question"
    }

    private var recordingIndicator: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(.red)
                .frame(width: 6, height: 6)
            Text("Recording")
                .font(.caption2)
                .foregroundStyle(.secondary)
            Spacer()
            Text("Press again to stop")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 4)
    }

    private var cancelButton: some View {
        Button {
            delegate.cancelRecording()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 11))
                Text("Cancel")
                    .font(.caption)
                Spacer()
                Text("Esc")
                    .font(.system(.caption2, design: .rounded, weight: .medium))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 3))
            }
            .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 4)
    }

    private var processingIndicator: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
            Text("Transcribing and analyzing...")
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }

    // MARK: - Setup Section

    private var setupSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Setup Required", systemImage: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundStyle(.orange)

            permissionRow("Screen Recording", granted: appState.hasScreenCapturePermission, anchor: "screenRecording")
            permissionRow("Microphone", granted: appState.hasMicrophonePermission, anchor: "microphone")
            permissionRow("Accessibility (hotkey)", granted: appState.hasAccessibilityPermission, anchor: "accessibility")

            Button("Refresh Status") {
                delegate.checkPermissions()
            }
            .font(.caption)
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
    }

    private func permissionRow(_ name: String, granted: Bool, anchor: String) -> some View {
        Button {
            if !granted {
                delegate.openSystemPreferences(anchor)
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: granted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(granted ? .green : .secondary)
                    .font(.system(size: 12))
                Text(name)
                    .font(.caption)
                Spacer()
                if !granted {
                    Text("Grant")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var loadingModelBanner: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
            VStack(alignment: .leading, spacing: 2) {
                Text("Loading Whisper model...")
                    .font(.caption)
                Text("First launch downloads ~142MB")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
            Spacer()
        }
    }

    private var hotkeyWarning: some View {
        HStack(spacing: 8) {
            Image(systemName: "keyboard")
                .foregroundStyle(.orange)
                .font(.system(size: 12))
            VStack(alignment: .leading, spacing: 2) {
                Text("Global hotkey inactive")
                    .font(.caption)
                Text("Grant Accessibility permission for Cmd+Shift+V")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }

    // MARK: - Error

    private func errorBanner(_ message: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
                .font(.system(size: 12))
            Text(message)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(3)
            Spacer()
        }
    }

    // MARK: - Last Result

    private var lastResultSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let transcription = appState.lastTranscription {
                HStack(spacing: 4) {
                    Image(systemName: "waveform")
                        .font(.system(size: 9))
                        .foregroundStyle(.tertiary)
                    Text(transcription)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }

            if let instruction = appState.lastInstruction {
                HStack(alignment: .top, spacing: 8) {
                    Text(instruction.keySequence)
                        .font(.system(.title3, design: .monospaced, weight: .bold))
                        .foregroundStyle(.primary)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(instruction.explanation)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)

                        if let alts = instruction.alternativeKeys, !alts.isEmpty {
                            HStack(spacing: 3) {
                                ForEach(alts.prefix(3), id: \.self) { alt in
                                    Text(alt)
                                        .font(.system(.caption2, design: .monospaced))
                                        .padding(.horizontal, 3)
                                        .padding(.vertical, 1)
                                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 3))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Footer

    private var footerSection: some View {
        VStack(spacing: 0) {
            SettingsLink {
                Label("Settings", systemImage: "gear")
            }

            Divider()
                .padding(.horizontal, 8)

            Button(role: .destructive) {
                NSApplication.shared.terminate(nil)
            } label: {
                Label("Quit NvimVoice", systemImage: "power")
            }
            .keyboardShortcut("q")
        }
    }
}

