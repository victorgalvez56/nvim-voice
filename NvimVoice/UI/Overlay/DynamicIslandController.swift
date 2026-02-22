import AppKit
import SwiftUI

@MainActor
final class DynamicIslandController {
    private var panel: DynamicIslandPanel?
    private var dismissTask: Task<Void, Never>?
    private let islandState = IslandState()
    var keyboardLayout: KeyboardLayout?

    private var hasNotch: Bool {
        if #available(macOS 12.0, *) {
            return NSScreen.main?.auxiliaryTopLeftArea != nil
        }
        return false
    }

    private var pillTopOffset: CGFloat {
        guard let screen = NSScreen.main else { return 12 }
        if #available(macOS 12.0, *) {
            let safeTop = screen.safeAreaInsets.top
            if safeTop > 0 {
                // Position just below the notch safe area
                return safeTop + 4
            }
        }
        // No notch: position below the menu bar
        let menuBarHeight = screen.frame.height - screen.visibleFrame.height - screen.visibleFrame.origin.y + screen.frame.origin.y
        return menuBarHeight + 4
    }

    func showRecording() {
        ensurePanel()
        islandState.phase = .recording
    }

    func showProcessing() {
        ensurePanel()
        islandState.phase = .processing
    }

    func showInstruction(_ instruction: NvimInstruction, duration: TimeInterval = 8.0) {
        ensurePanel()
        islandState.phase = .expanded(instruction)
        scheduleCollapse(instruction: instruction, after: duration)
    }

    func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil
        islandState.phase = .hidden

        // Remove panel after animation completes
        Task { [weak self] in
            try? await Task.sleep(for: .seconds(0.5))
            guard let self else { return }
            self.panel?.orderOut(nil)
            self.panel = nil
        }
    }

    // MARK: - Private

    private func ensurePanel() {
        guard panel == nil else { return }

        guard let screen = NSScreen.main else { return }

        let panelHeight: CGFloat = 700
        let panelRect = NSRect(
            x: screen.frame.origin.x,
            y: screen.frame.maxY - panelHeight,
            width: screen.frame.width,
            height: panelHeight
        )

        let panel = DynamicIslandPanel(contentRect: panelRect)

        let hostingView = NSHostingView(
            rootView: DynamicIslandView(
                state: islandState,
                keyboardLayout: keyboardLayout,
                pillTopOffset: pillTopOffset
            )
        )
        panel.contentView = hostingView
        panel.orderFront(nil)
        self.panel = panel
    }

    private func scheduleCollapse(instruction: NvimInstruction, after duration: TimeInterval) {
        dismissTask?.cancel()
        dismissTask = Task { [weak self] in
            // Wait for the overlay duration, then collapse
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }

            self?.islandState.phase = .collapsing(instruction)

            // Wait a bit in collapsed state, then dismiss
            try? await Task.sleep(for: .seconds(1.5))
            guard !Task.isCancelled else { return }

            self?.dismiss()
        }
    }
}
