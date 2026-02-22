import Foundation
import IOKit
import IOKit.hid

@MainActor
final class USBKeyboardDetector {
    static let shared = USBKeyboardDetector()

    private(set) var isConnected: Bool = false
    var onConnectionChanged: ((Bool) -> Void)?

    private let zsaVendorID: Int = 0x3297
    private var notifyPort: IONotificationPortRef?
    private var matchIterators: [io_iterator_t] = []
    private var removeIterators: [io_iterator_t] = []

    private init() {}

    func start() {
        isConnected = checkConnected()
        Log.info("ZSA keyboard initially connected: \(isConnected)")
        setupNotifications()
    }

    func stop() {
        for iterator in matchIterators + removeIterators where iterator != 0 {
            IOObjectRelease(iterator)
        }
        matchIterators.removeAll()
        removeIterators.removeAll()
        if let port = notifyPort {
            IONotificationPortDestroy(port)
            notifyPort = nil
        }
    }

    func checkConnected() -> Bool {
        let matching = IOServiceMatching("IOHIDDevice") as NSMutableDictionary
        matching["VendorID"] = zsaVendorID

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

        // Connect notification
        if let matchDict = IOServiceMatching("IOHIDDevice") as NSMutableDictionary? {
            matchDict["VendorID"] = zsaVendorID
            var iterator: io_iterator_t = 0
            let matchCallback: IOServiceMatchingCallback = { refcon, iter in
                guard let refcon else { return }
                var service = IOIteratorNext(iter)
                while service != 0 {
                    IOObjectRelease(service)
                    service = IOIteratorNext(iter)
                }
                let detector = Unmanaged<USBKeyboardDetector>.fromOpaque(refcon).takeUnretainedValue()
                Task { @MainActor in
                    detector.handleConnectionChange()
                }
            }
            IOServiceAddMatchingNotification(
                port,
                kIOMatchedNotification,
                matchDict as CFDictionary,
                matchCallback,
                context,
                &iterator
            )
            drainIterator(iterator)
            matchIterators.append(iterator)
        }

        // Disconnect notification
        if let removeDict = IOServiceMatching("IOHIDDevice") as NSMutableDictionary? {
            removeDict["VendorID"] = zsaVendorID
            var iterator: io_iterator_t = 0
            let removeCallback: IOServiceMatchingCallback = { refcon, iter in
                guard let refcon else { return }
                var service = IOIteratorNext(iter)
                while service != 0 {
                    IOObjectRelease(service)
                    service = IOIteratorNext(iter)
                }
                let detector = Unmanaged<USBKeyboardDetector>.fromOpaque(refcon).takeUnretainedValue()
                Task { @MainActor in
                    detector.handleConnectionChange()
                }
            }
            IOServiceAddMatchingNotification(
                port,
                kIOTerminatedNotification,
                removeDict as CFDictionary,
                removeCallback,
                context,
                &iterator
            )
            drainIterator(iterator)
            removeIterators.append(iterator)
        }
    }

    private func drainIterator(_ iterator: io_iterator_t) {
        var service = IOIteratorNext(iterator)
        while service != 0 {
            IOObjectRelease(service)
            service = IOIteratorNext(iterator)
        }
    }

    private func handleConnectionChange() {
        let nowConnected = checkConnected()
        guard nowConnected != isConnected else { return }
        isConnected = nowConnected
        Log.info("ZSA keyboard connection changed: \(isConnected)")
        onConnectionChanged?(isConnected)
    }
}
