import Foundation

// MARK: - Geometry

enum KeyboardGeometry: String, Codable {
    case moonlander = "moonlander"
    case voyager = "voyager"
    case ergodoxEz = "ergodox-ez"
    case standard = "standard"

    var displayName: String {
        switch self {
        case .moonlander: return "Moonlander"
        case .voyager: return "Voyager"
        case .ergodoxEz: return "ErgoDox EZ"
        case .standard: return "Standard ANSI"
        }
    }

    var keyCount: Int {
        switch self {
        case .moonlander: return 72
        case .voyager: return 52
        case .ergodoxEz: return 76
        case .standard: return 61
        }
    }

    var isSplit: Bool {
        switch self {
        case .moonlander, .voyager, .ergodoxEz: return true
        case .standard: return false
        }
    }
}

// MARK: - Layout

struct KeyboardLayout {
    let title: String
    let geometry: KeyboardGeometry
    let layers: [KeyboardLayer]
}

struct KeyboardLayer {
    let title: String
    let keys: [KeyAction]
}

struct KeyAction {
    let tap: KeyCode?
    let hold: KeyCode?
    let holdLayer: Int?
    let customLabel: String?

    var isEmpty: Bool {
        tap == nil && hold == nil && holdLayer == nil && customLabel == nil
    }

    var isTransparent: Bool {
        tap?.code == "KC_TRANSPARENT" || tap?.code == "KC_TRNS"
    }
}

struct KeyCode {
    let code: String
    let label: String

    init(code: String) {
        self.code = code
        self.label = KeyCodeMapping.humanLabel(for: code)
    }
}

// MARK: - Physical Position

enum Hand: String {
    case left, right
}

enum FingerName: String {
    case pinky, ring, middle, index, thumb
}

enum RowName: String {
    case numberRow = "number row"
    case topRow = "top row"
    case homeRow = "home row"
    case bottomRow = "bottom row"
    case functionRow = "function row"
    case thumbCluster = "thumb cluster"
}

struct PhysicalKeyPosition {
    let hand: Hand
    let finger: FingerName
    let row: RowName

    var shortDescription: String {
        "\(hand.rawValue) \(finger.rawValue), \(row.rawValue)"
    }
}
