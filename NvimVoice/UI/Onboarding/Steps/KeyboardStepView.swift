import SwiftUI

struct KeyboardStepView: View {
    @Bindable var state: OnboardingState

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "keyboard")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)

            Text("Keyboard Layout")
                .font(.title.bold())

            if let layout = state.detectedKeyboardLayout {
                Text(state.isZSADetected
                     ? "ZSA split keyboard detected via Keymapp."
                     : "No ZSA keyboard found. Using standard ANSI layout.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)

                KeyboardMapView(layout: layout, compact: true)
                    .padding(.horizontal, 32)

                HStack(spacing: 24) {
                    Label(layout.geometry.displayName, systemImage: "keyboard")
                    Label("\"\(layout.title)\"", systemImage: "tag")
                    Label("\(layout.layers.count) layer\(layout.layers.count == 1 ? "" : "s")", systemImage: "square.3.layers.3d")
                }
                .font(.caption)
                .foregroundStyle(.tertiary)
            } else {
                ProgressView("Detecting keyboard...")
            }
        }
        .onAppear {
            if state.detectedKeyboardLayout == nil {
                state.detectKeyboard()
            }
        }
    }
}
