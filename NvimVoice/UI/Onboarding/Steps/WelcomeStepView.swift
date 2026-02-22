import SwiftUI

struct WelcomeStepView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "chevron.left.forwardslash.chevron.right")
                .font(.system(size: 48))
                .foregroundStyle(Color.accentColor)

            Text("Welcome to NvimVoice")
                .font(.largeTitle.bold())

            VStack(alignment: .leading, spacing: 16) {
                featureRow(
                    icon: "mic.fill",
                    title: "Speak Your Intent",
                    description: "Describe what you want to do in natural language"
                )
                featureRow(
                    icon: "eye.fill",
                    title: "AI Analyzes Your Screen",
                    description: "OpenAI vision reads your editor context"
                )
                featureRow(
                    icon: "keyboard.fill",
                    title: "See Exact Keys",
                    description: "Get the precise Vim keystrokes to execute"
                )
            }
            .padding(.horizontal, 48)
        }
    }

    private func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
