import SwiftUI

struct MenuBarView: View {
    let appState: AppState
    let delegate: AppDelegate

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status
            HStack {
                Circle()
                    .fill(statusColor)
                    .frame(width: 8, height: 8)
                Text(appState.statusText)
                    .font(.headline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            // Permissions
            permissionsSection

            Divider()

            // Last result
            if let transcription = appState.lastTranscription {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last voice command:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(transcription)
                        .font(.caption)
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }

            if let instruction = appState.lastInstruction {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last command:")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(instruction.keySequence)
                        .font(.system(.body, design: .monospaced, weight: .bold))
                    Text(instruction.explanation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }

            if let error = appState.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.yellow)
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                        .lineLimit(3)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }

            Divider()

            // Actions
            Button("Request Permissions") {
                delegate.requestAllPermissions()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)

            SettingsLink {
                Text("Settings...")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)

            Divider()

            Button("Quit NvimVoice") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
        }
        .frame(width: 280)
    }

    private var statusColor: Color {
        if appState.isRecording { return .green }
        if appState.isProcessing { return .orange }
        return .gray
    }

    private var permissionsSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Permissions")
                .font(.caption)
                .foregroundStyle(.secondary)
            permissionRow("Screen Recording", granted: appState.hasScreenCapturePermission)
            permissionRow("Microphone", granted: appState.hasMicrophonePermission)
            permissionRow("Accessibility", granted: appState.hasAccessibilityPermission)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
    }

    private func permissionRow(_ name: String, granted: Bool) -> some View {
        HStack(spacing: 6) {
            Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(granted ? .green : .red)
                .font(.caption)
            Text(name)
                .font(.caption)
        }
    }
}
