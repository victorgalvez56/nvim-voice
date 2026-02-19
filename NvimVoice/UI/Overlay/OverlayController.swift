import AppKit
import SwiftUI

@MainActor
final class OverlayController {
    private var panel: OverlayPanel?
    private var dismissTask: Task<Void, Never>?

    func showProcessing() {
        show(state: .processing)
    }

    func showInstruction(_ instruction: NvimInstruction, duration: TimeInterval = 8.0) {
        show(state: .result(instruction))
        scheduleDismiss(after: duration)
    }

    func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil

        guard let panel else { return }

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            panel.animator().alphaValue = 0
        }, completionHandler: { [weak self] in
            MainActor.assumeIsolated {
                self?.panel?.orderOut(nil)
                self?.panel = nil
            }
        })
    }

    private func show(state: OverlayState) {
        dismissTask?.cancel()

        let contentView = OverlayContentView(state: state)
        let hostingView = NSHostingView(rootView: contentView)
        hostingView.frame.size = hostingView.fittingSize

        let panelRect = calculatePosition(for: hostingView.fittingSize)

        if let panel {
            panel.contentView = hostingView
            panel.setFrame(panelRect, display: true)
        } else {
            let panel = OverlayPanel(contentRect: panelRect)
            panel.contentView = hostingView
            panel.alphaValue = 0
            self.panel = panel
        }

        panel?.orderFront(nil)

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            panel?.animator().alphaValue = 1
        }
    }

    private func calculatePosition(for size: NSSize) -> NSRect {
        guard let screen = NSScreen.main else {
            return NSRect(origin: .zero, size: size)
        }

        let padding: CGFloat = 20
        let x = screen.visibleFrame.maxX - size.width - padding
        let y = screen.visibleFrame.minY + padding

        return NSRect(origin: NSPoint(x: x, y: y), size: size)
    }

    private func scheduleDismiss(after duration: TimeInterval) {
        dismissTask?.cancel()
        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            self?.dismiss()
        }
    }
}
