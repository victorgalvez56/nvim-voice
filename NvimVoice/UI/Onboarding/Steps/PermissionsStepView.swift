import SwiftUI

struct PermissionsStepView: View {
    @Bindable var state: OnboardingState
    let delegate: AppDelegate

    var body: some View {
        VStack(spacing: 24) {
            Text("Permissions")
                .font(.title.bold())

            Text("NvimVoice needs these permissions to capture your screen, listen to voice commands, and send keystrokes.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)

            VStack(spacing: 12) {
                permissionRow(
                    title: "Screen Recording",
                    subtitle: "Capture editor content for AI analysis",
                    granted: state.hasScreenCapture,
                    action: { delegate.openSystemPreferences("screenRecording") }
                )

                permissionRow(
                    title: "Microphone",
                    subtitle: "Record voice commands",
                    granted: state.hasMicrophone,
                    action: {
                        Task { await state.refreshMicrophone() }
                    }
                )

                permissionRow(
                    title: "Accessibility",
                    subtitle: "Register global hotkey and send keystrokes",
                    granted: state.hasAccessibility,
                    action: { delegate.openSystemPreferences("accessibility") }
                )
            }
            .padding(.horizontal, 48)

            Button("Refresh Status") {
                state.refreshPermissions()
                Task { await state.refreshMicrophone() }
            }
            .buttonStyle(.bordered)

            if !state.allPermissionsGranted {
                Text("Grant all permissions to continue")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
        .onAppear {
            state.refreshPermissions()
            Task { await state.refreshMicrophone() }
        }
    }

    private func permissionRow(
        title: String,
        subtitle: String,
        granted: Bool,
        action: @escaping () -> Void
    ) -> some View {
        HStack {
            Image(systemName: granted ? "checkmark.circle.fill" : "xmark.circle")
                .foregroundStyle(granted ? .green : .red)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if !granted {
                Button("Open Settings") { action() }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(.quaternary))
    }
}
