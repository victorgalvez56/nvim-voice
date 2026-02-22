import SwiftUI

struct APIKeyStepView: View {
    @Bindable var state: OnboardingState
    @State private var showKey = false
    @State private var saveStatus: String?

    var body: some View {
        VStack(spacing: 24) {
            Text("OpenAI API Key")
                .font(.title.bold())

            Text("NvimVoice uses OpenAI's vision API to analyze your screen and generate Vim commands.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 48)

            VStack(spacing: 12) {
                HStack {
                    if showKey {
                        TextField("sk-...", text: $state.apiKey)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        SecureField("sk-...", text: $state.apiKey)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    }

                    Button(action: { showKey.toggle() }) {
                        Image(systemName: showKey ? "eye.slash" : "eye")
                    }
                    .buttonStyle(.borderless)
                }

                HStack {
                    Button("Save") {
                        do {
                            try KeychainHelper.saveAPIKey(state.apiKey)
                            state.apiKeySaved = true
                            saveStatus = "Saved"
                        } catch {
                            saveStatus = "Error: \(error.localizedDescription)"
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(state.apiKey.isEmpty)

                    if let status = saveStatus {
                        Text(status)
                            .font(.caption)
                            .foregroundStyle(status.hasPrefix("Error") ? .red : .green)
                    }
                }
            }
            .padding(.horizontal, 64)

            Text("Your key is encrypted and stored locally.")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .onAppear {
            if let key = KeychainHelper.loadAPIKey() {
                state.apiKey = key
                state.apiKeySaved = true
            }
        }
    }
}
