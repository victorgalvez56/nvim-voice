import SwiftUI

struct WhisperModelStepView: View {
    @Bindable var state: OnboardingState

    private let models: [(id: String, name: String, size: String, description: String)] = [
        ("tiny", "Tiny", "~75 MB", "Fastest, least accurate"),
        ("base", "Base", "~142 MB", "Good balance of speed and accuracy"),
        ("small", "Small", "~466 MB", "Most accurate, slower download"),
    ]

    var body: some View {
        VStack(spacing: 24) {
            Text("Whisper Model")
                .font(.title.bold())

            Text("Choose a speech recognition model. Larger models are more accurate but take longer to download.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)

            VStack(spacing: 8) {
                ForEach(models, id: \.id) { model in
                    modelRow(model)
                }
            }
            .padding(.horizontal, 64)

            Text("You can change this later in Settings.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    private func modelRow(_ model: (id: String, name: String, size: String, description: String)) -> some View {
        Button {
            state.selectedModel = model.id
        } label: {
            HStack {
                Image(systemName: state.selectedModel == model.id ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(state.selectedModel == model.id ? Color.accentColor : Color.secondary)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(model.name)
                            .font(.headline)
                        Text(model.size)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(model.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(state.selectedModel == model.id ? Color.accentColor.opacity(0.1) : Color.secondary.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(state.selectedModel == model.id ? Color.accentColor.opacity(0.5) : .clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
