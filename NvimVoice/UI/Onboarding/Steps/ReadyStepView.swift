import SwiftUI

struct ReadyStepView: View {
    let state: OnboardingState

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 48))
                .foregroundStyle(.green)

            Text("You're All Set")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 12) {
                summaryRow(
                    icon: "checkmark.circle.fill",
                    color: state.allPermissionsGranted ? .green : .orange,
                    text: state.allPermissionsGranted ? "All permissions granted" : "Some permissions missing"
                )
                summaryRow(
                    icon: "checkmark.circle.fill",
                    color: state.apiKeySaved ? .green : .orange,
                    text: state.apiKeySaved ? "API key saved" : "API key not set"
                )
                summaryRow(
                    icon: "arrow.down.circle.fill",
                    color: .blue,
                    text: "Whisper \(state.selectedModel) model will download on first use"
                )
            }
            .padding(.horizontal, 64)

            VStack(spacing: 8) {
                Text("Press  Cmd + Shift + V  to start recording")
                    .font(.system(.body, design: .monospaced))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 8).fill(.quaternary))

                Text("Press  Escape  to cancel")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func summaryRow(icon: String, color: Color, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(color)
            Text(text)
                .font(.subheadline)
        }
    }
}
