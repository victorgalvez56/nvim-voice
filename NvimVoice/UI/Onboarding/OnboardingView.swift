import SwiftUI

struct OnboardingView: View {
    @Bindable var state: OnboardingState
    let delegate: AppDelegate
    let onFinish: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            stepIndicator
                .padding(.top, 24)

            Spacer()

            stepContent
                .frame(maxWidth: .infinity)

            Spacer()

            navigationBar
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
        }
        .frame(width: 600, height: 500)
    }

    // MARK: - Step Indicator

    private var stepIndicator: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingStep.allCases, id: \.rawValue) { step in
                Circle()
                    .fill(step == state.currentStep ? Color.accentColor : Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }

    // MARK: - Step Content

    @ViewBuilder
    private var stepContent: some View {
        switch state.currentStep {
        case .welcome:
            WelcomeStepView()
        case .permissions:
            PermissionsStepView(state: state, delegate: delegate)
        case .apiKey:
            APIKeyStepView(state: state)
        case .whisperModel:
            WhisperModelStepView(state: state)
        case .ready:
            ReadyStepView(state: state)
        }
    }

    // MARK: - Navigation

    private var navigationBar: some View {
        HStack {
            if state.currentStep != .welcome {
                Button("Back") {
                    state.goBack()
                }
                .keyboardShortcut(.leftArrow, modifiers: [])
            }

            Spacer()

            Button(state.isLastStep ? "Get Started" : "Continue") {
                if state.isLastStep {
                    onFinish()
                } else {
                    state.advance()
                }
            }
            .keyboardShortcut(.return, modifiers: [])
            .buttonStyle(.borderedProminent)
            .disabled(!state.canAdvance)
        }
    }
}
