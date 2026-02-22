import AppKit
import SwiftUI

@MainActor
final class OnboardingController: NSObject, NSWindowDelegate {
    private var panel: OnboardingPanel?
    private var onComplete: (() -> Void)?
    private var onboardingState: OnboardingState?
    private weak var appState: AppState?

    func show(appState: AppState, delegate: AppDelegate, onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
        self.appState = appState

        let state = OnboardingState()
        state.selectedModel = appState.whisperModel
        self.onboardingState = state

        let view = OnboardingView(state: state, delegate: delegate) { [weak self] in
            self?.completeOnboarding()
        }

        let panel = OnboardingPanel()
        panel.contentView = NSHostingView(rootView: view)
        panel.delegate = self
        self.panel = panel

        // Defer display to after the run loop is fully initialized
        DispatchQueue.main.async {
            panel.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func windowWillClose(_ notification: Notification) {
        // User closed the window early — app should still be usable,
        // but onboardingCompleted stays false so it reappears next launch
        onComplete?()
        onComplete = nil
    }

    private func completeOnboarding() {
        if let model = onboardingState?.selectedModel {
            appState?.whisperModel = model
        }
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        panel?.delegate = nil // prevent windowWillClose from firing again
        panel?.orderOut(nil)
        panel = nil
        onComplete?()
        onComplete = nil
    }
}
