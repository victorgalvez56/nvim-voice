import Carbon
import CoreGraphics
import AppKit

final class HotkeyService {
    var onToggle: (() -> Void)?
    var onCancel: (() -> Void)?
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var retryTimer: Timer?

    func start() {
        // Must register on main thread for the main RunLoop
        if Thread.isMainThread {
            createEventTap()
        } else {
            DispatchQueue.main.sync { createEventTap() }
        }
    }

    /// Retry creating the event tap (useful after Accessibility is granted)
    func retryUntilReady() {
        guard eventTap == nil else { return }
        retryTimer?.invalidate()
        retryTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            if AccessibilityPermission.hasPermission() {
                self.start()
                if self.eventTap != nil {
                    timer.invalidate()
                    self.retryTimer = nil
                    Log.info("[HotkeyService] Event tap created successfully after permission grant")
                }
            }
        }
    }

    var isActive: Bool { eventTap != nil }

    func stop() {
        retryTimer?.invalidate()
        retryTimer = nil
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetMain(), source, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
    }

    private func createEventTap() {
        let mask: CGEventMask = (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.flagsChanged.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: mask,
            callback: { _, type, event, refcon -> Unmanaged<CGEvent>? in
                guard let refcon else { return Unmanaged.passRetained(event) }
                let service = Unmanaged<HotkeyService>.fromOpaque(refcon).takeUnretainedValue()

                // macOS disables event taps after timeout; re-enable
                if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
                    if let tap = service.eventTap {
                        CGEvent.tapEnable(tap: tap, enable: true)
                    }
                    return Unmanaged.passRetained(event)
                }

                return service.handleEvent(type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        ) else {
            Log.info("[HotkeyService] Failed to create event tap — Accessibility permission required")
            retryUntilReady()
            return
        }

        self.eventTap = tap
        let source = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        self.runLoopSource = source
        CFRunLoopAddSource(CFRunLoopGetMain(), source, .commonModes)
        CGEvent.tapEnable(tap: tap, enable: true)
        Log.info("[HotkeyService] Global hotkey Cmd+Shift+V registered")
    }

    private func handleEvent(type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        guard type == .keyDown else {
            return Unmanaged.passRetained(event)
        }

        let flags = event.flags
        let keyCode = event.getIntegerValueField(.keyboardEventKeycode)

        // Cmd+Shift+V: keyCode 9 = V
        let hasCmd = flags.contains(.maskCommand)
        let hasShift = flags.contains(.maskShift)
        // Exclude if other modifiers are held (Alt, Ctrl)
        let hasAlt = flags.contains(.maskAlternate)
        let hasCtrl = flags.contains(.maskControl)

        // Cmd+Shift+V → toggle recording
        if hasCmd && hasShift && !hasAlt && !hasCtrl && keyCode == 9 {
            DispatchQueue.main.async { [weak self] in
                self?.onToggle?()
            }
            return nil
        }

        // Escape (keyCode 53) → cancel recording
        if keyCode == 53 && !hasCmd && !hasShift && !hasAlt && !hasCtrl {
            DispatchQueue.main.async { [weak self] in
                self?.onCancel?()
            }
            // Don't consume Escape — let it pass through to other apps too
        }

        return Unmanaged.passRetained(event)
    }

    deinit {
        stop()
    }
}
