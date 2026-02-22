import SwiftUI

@main
struct NvimVoiceApp: App {
    @NSApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(appState: appDelegate.appState, delegate: appDelegate.delegate)
        } label: {
            Image(systemName: appDelegate.appState.menuBarIcon)
        }

        Settings {
            SettingsView(appState: appDelegate.appState)
        }
    }
}

@MainActor
final class AppDelegateAdaptor: NSObject, NSApplicationDelegate {
    let appState = AppState()
    lazy var delegate = AppDelegate(appState: appState)

    func applicationDidFinishLaunching(_ notification: Notification) {
        delegate.applicationDidFinishLaunching(notification)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(windowDidBecomeKey),
            name: NSWindow.didBecomeKeyNotification,
            object: nil
        )
    }

    @objc private func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        if window.level == .normal {
            window.level = .floating
        }
        window.orderFrontRegardless()
        NSApp.activate(ignoringOtherApps: true)
    }
}
