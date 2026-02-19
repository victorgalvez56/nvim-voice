import SwiftUI

struct SettingsView: View {
    let appState: AppState
    @State private var apiKey: String = ""
    @State private var showAPIKey = false
    @State private var saveStatus: String?

    var body: some View {
        TabView {
            generalTab
                .tabItem {
                    Label("General", systemImage: "gear")
                }

            apiTab
                .tabItem {
                    Label("API", systemImage: "key")
                }
        }
        .frame(width: 450, height: 300)
        .onAppear {
            if let key = KeychainHelper.loadAPIKey() {
                apiKey = key
            }
        }
    }

    private var generalTab: some View {
        Form {
            Picker("Whisper Model", selection: Binding(
                get: { appState.whisperModel },
                set: { appState.whisperModel = $0 }
            )) {
                Text("Tiny (~75MB)").tag("tiny")
                Text("Base (~142MB)").tag("base")
                Text("Small (~466MB)").tag("small")
            }
            .help("Smaller models are faster but less accurate")

            Picker("Overlay Duration", selection: Binding(
                get: { appState.overlayDuration },
                set: { appState.overlayDuration = $0 }
            )) {
                Text("5 seconds").tag(5.0)
                Text("8 seconds").tag(8.0)
                Text("12 seconds").tag(12.0)
                Text("15 seconds").tag(15.0)
            }

            Picker("Image Detail", selection: Binding(
                get: { appState.imageDetail },
                set: { appState.imageDetail = $0 }
            )) {
                Text("Low (65 tokens)").tag("low")
                Text("High (more tokens)").tag("high")
                Text("Auto").tag("auto")
            }
            .help("Low uses fewer tokens and is faster. High provides better analysis.")

            Section("Hotkey") {
                Text("Cmd + Shift + V")
                    .font(.system(.body, design: .monospaced))
                    .foregroundStyle(.secondary)
                Text("Press to start/stop recording")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding()
    }

    private var apiTab: some View {
        Form {
            Section("OpenAI API Key") {
                HStack {
                    if showAPIKey {
                        TextField("sk-...", text: $apiKey)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    } else {
                        SecureField("sk-...", text: $apiKey)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(.body, design: .monospaced))
                    }

                    Button(action: { showAPIKey.toggle() }) {
                        Image(systemName: showAPIKey ? "eye.slash" : "eye")
                    }
                    .buttonStyle(.borderless)
                }

                HStack {
                    Button("Save") {
                        do {
                            try KeychainHelper.saveAPIKey(apiKey)
                            saveStatus = "Saved to Keychain"
                        } catch {
                            saveStatus = "Error: \(error.localizedDescription)"
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    if let status = saveStatus {
                        Text(status)
                            .font(.caption)
                            .foregroundStyle(status.hasPrefix("Error") ? .red : .green)
                    }
                }
            }

            Section {
                Text("Your API key is stored securely in the macOS Keychain.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}
