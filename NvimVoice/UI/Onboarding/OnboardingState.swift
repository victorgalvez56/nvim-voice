import SwiftUI
import Observation

enum OnboardingStep: Int, CaseIterable {
    case welcome
    case permissions
    case apiKey
    case whisperModel
    case keyboard
    case ready
}

@Observable
@MainActor
final class OnboardingState {
    var currentStep: OnboardingStep = .welcome

    // Permissions
    var hasScreenCapture = false
    var hasMicrophone = false
    var hasAccessibility = false

    // API Key
    var apiKey: String = ""
    var apiKeySaved = false

    // Model
    var selectedModel: String = "base"

    // Keyboard
    var detectedKeyboardLayout: KeyboardLayout?
    var isZSADetected: Bool = false

    var allPermissionsGranted: Bool {
        hasScreenCapture && hasMicrophone && hasAccessibility
    }

    var canAdvance: Bool {
        switch currentStep {
        case .welcome, .whisperModel, .keyboard, .ready:
            return true
        case .permissions:
            return allPermissionsGranted
        case .apiKey:
            return apiKeySaved
        }
    }

    var isLastStep: Bool {
        currentStep == .ready
    }

    func advance() {
        guard canAdvance else { return }
        let all = OnboardingStep.allCases
        guard let idx = all.firstIndex(of: currentStep), idx + 1 < all.count else { return }
        currentStep = all[idx + 1]
    }

    func goBack() {
        let all = OnboardingStep.allCases
        guard let idx = all.firstIndex(of: currentStep), idx > 0 else { return }
        currentStep = all[idx - 1]
    }

    func refreshPermissions() {
        hasScreenCapture = ScreenCapturePermission.hasPermission()
        hasAccessibility = AccessibilityPermission.hasPermission()
    }

    func refreshMicrophone() async {
        hasMicrophone = await AudioPermission.requestPermission()
    }

    func detectKeyboard() {
        let keymappService = KeymappService()
        if let zsaLayout = keymappService.loadLayout() {
            detectedKeyboardLayout = zsaLayout
            isZSADetected = true
        } else {
            detectedKeyboardLayout = StandardLayoutProvider.layout()
            isZSADetected = false
        }
    }
}
