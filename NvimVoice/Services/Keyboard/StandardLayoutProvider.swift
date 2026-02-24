import Foundation

enum StandardLayoutProvider {
    static func layout() -> KeyboardLayout {
        KeyboardLayout(
            title: "Standard",
            geometry: .standard,
            layers: [KeyboardLayer(title: "Base", keys: keys)]
        )
    }

    // 61-key ANSI layout
    // Row 0 (14): Esc  1  2  3  4  5  6  7  8  9  0  -  =  Bksp
    // Row 1 (14): Tab  Q  W  E  R  T  Y  U  I  O  P  [  ]  \
    // Row 2 (13): Caps A  S  D  F  G  H  J  K  L  ;  '  Enter
    // Row 3 (12): LShift Z  X  C  V  B  N  M  ,  .  /  RShift
    // Row 4  (8): LCtrl LAlt LCmd Space RCmd RAlt Left Right

    private static let keys: [KeyAction] = {
        let codes: [String] = [
            // Row 0
            "KC_ESC", "KC_1", "KC_2", "KC_3", "KC_4", "KC_5", "KC_6",
            "KC_7", "KC_8", "KC_9", "KC_0", "KC_MINS", "KC_EQL", "KC_BSPC",
            // Row 1
            "KC_TAB", "KC_Q", "KC_W", "KC_E", "KC_R", "KC_T", "KC_Y",
            "KC_U", "KC_I", "KC_O", "KC_P", "KC_LBRC", "KC_RBRC", "KC_BSLS",
            // Row 2
            "KC_CAPS", "KC_A", "KC_S", "KC_D", "KC_F", "KC_G", "KC_H",
            "KC_J", "KC_K", "KC_L", "KC_SCLN", "KC_QUOT", "KC_ENT",
            // Row 3
            "KC_LSFT", "KC_Z", "KC_X", "KC_C", "KC_V", "KC_B", "KC_N",
            "KC_M", "KC_COMM", "KC_DOT", "KC_SLSH", "KC_RSFT",
            // Row 4
            "KC_LCTL", "KC_LALT", "KC_LGUI", "KC_SPC", "KC_RGUI", "KC_RALT",
            "KC_LEFT", "KC_RIGHT",
        ]
        return codes.map { code in
            KeyAction(tap: KeyCode(code: code), hold: nil, holdLayer: nil, customLabel: nil)
        }
    }()
}
