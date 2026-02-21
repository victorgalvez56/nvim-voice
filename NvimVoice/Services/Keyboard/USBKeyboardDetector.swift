import Foundation
import IOKit
import IOKit.usb

@MainActor
final class USBKeyboardDetector {
    static let shared = USBKeyboardDetector()

    private(set) var isConnected: Bool = false
    var onConnectionChanged: ((Bool) -> Void)?

    private let zsaVendorID: Int = 0x3297
    private var notifyPort: IONotificationPortRef?
    private var matchIterator: io_iterator_t = 0
    private var removeIterator: io_iterator_t = 0

    private init() {}

    func start() {
        isConnected = checkConnected()
        Log.info("ZSA keyboard initially connected: \(isConnected)")
        setupNotifications()
    }

    func stop() {
        if matchIterator != 0 {
            IOObjectRelease(matchIterator)
            matchIterator = 0
        }
        if removeIterator != 0 {
            IOObjectRelease(removeIterator)
            removeIterator = 0
        }
        if let port = notifyPort {
            IONotificationPortDestroy(port)
            notifyPort = nil
        }
    }

    func checkConnected() -> Bool {
        let matching = IOServiceMatching(kIOUSBDeviceClassName) as NSMutableDictionary
        matching[kUSBVendorID] = zsaVendorID

        var iterator: io_iterator_t = 0
        let result = IOServiceGetMatchingServices(kIOMainPortDefault, matching, &iterator)
        guard result == KERN_SUCCESS else { return false }

        var found = false
        var service = IOIteratorNext(iterator)
        while service != 0 {
            found = true
            IOObjectRelease(service)
            service = IOIteratorNext(iterator)
        }
        IOObjectRelease(iterator)
        return found
    }

    // MARK: - Notifications

    private func setupNotifications() {
        notifyPort = IONotificationPortCreate(kIOMainPortDefault)
        guard let port = notifyPort else {
            Log.info("Failed to create IONotificationPort")
            return
        }

        let runLoopSource = IONotificationPortGetRunLoopSource(port).takeUnretainedValue()
        CFRunLoopAddSource(CFRunLoopGetMain(), runLoopSource, .defaultMode)

        let context = Unmanaged.passUnretained(self).toOpaque()

        // Match notification
        if let matchDict = IOServiceMatching(kIOUSBDeviceClassName) as NSMutableDictionary? {
            matchDict[kUSBVendorID] = zsaVendorID
            let matchCallback: IOServiceMatchingCallback = { refcon, iterator in
                guard let refcon else { return }
                // Drain the iterator
                var service = IOIteratorNext(iterator)
                while service != 0 {
                    IOObjectRelease(service)
                    service = IOIteratorNext(iterator)
                }
                let detector = Unmanaged<USBKeyboardDetector>.fromOpaque(refcon).takeUnretainedValue()
                Task { @MainActor in
                    detector.handleConnectionChange(connected: true)
                }
            }
            IOServiceAddMatchingNotification(
                port,
                kIOMatchedNotification,
                matchDict as CFDictionary,
                matchCallback,
                context,
                &matchIterator
            )
            // Drain initial iterator to arm the notification
            drainIterator(matchIterator)
        }

        // Termination notification
        if let removeDict = IOServiceMatching(kIOUSBDeviceClassName) as NSMutableDictionary? {
            removeDict[kUSBVendorID] = zsaVendorID
            let removeCallback: IOServiceMatchingCallback = { refcon, iterator in
                guard let refcon else { return }
                var service = IOIteratorNext(iterator)
                while service != 0 {
                    IOObjectRelease(service)
                    service = IOIteratorNext(iterator)
                }
                let detector = Unmanaged<USBKeyboardDetector>.fromOpaque(refcon).takeUnretainedValue()
                Task { @MainActor in
                    detector.handleConnectionChange(connected: false)
                }
            }
            IOServiceAddMatchingNotification(
                port,
                kIOTerminatedNotification,
                removeDict as CFDictionary,
                removeCallback,
                context,
                &removeIterator
            )
            drainIterator(removeIterator)
        }
    }

    private func drainIterator(_ iterator: io_iterator_t) {
        var service = IOIteratorNext(iterator)
        while service != 0 {
            IOObjectRelease(service)
            service = IOIteratorNext(iterator)
        }
    }

    private func handleConnectionChange(connected: Bool) {
        // Re-scan to get accurate state (disconnect fires per-device)
        let nowConnected = checkConnected()
        guard nowConnected != isConnected else { return }
        isConnected = nowConnected
        Log.info("ZSA keyboard connection changed: \(isConnected)")
        onConnectionChanged?(isConnected)
    }
}
