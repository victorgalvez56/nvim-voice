import Foundation

enum KeyCodeMapping {
    static func humanLabel(for code: String) -> String {
        if let label = codes[code] {
            return label
        }
        // Fallback: strip KC_ prefix and title-case
        if code.hasPrefix("KC_") {
            return String(code.dropFirst(3))
                .replacingOccurrences(of: "_", with: " ")
                .capitalized
        }
        return code
    }

    // ~80 common QMK keycodes
    private static let codes: [String: String] = [
        // Letters
        "KC_A": "A", "KC_B": "B", "KC_C": "C", "KC_D": "D",
        "KC_E": "E", "KC_F": "F", "KC_G": "G", "KC_H": "H",
        "KC_I": "I", "KC_J": "J", "KC_K": "K", "KC_L": "L",
        "KC_M": "M", "KC_N": "N", "KC_O": "O", "KC_P": "P",
        "KC_Q": "Q", "KC_R": "R", "KC_S": "S", "KC_T": "T",
        "KC_U": "U", "KC_V": "V", "KC_W": "W", "KC_X": "X",
        "KC_Y": "Y", "KC_Z": "Z",

        // Numbers
        "KC_1": "1", "KC_2": "2", "KC_3": "3", "KC_4": "4",
        "KC_5": "5", "KC_6": "6", "KC_7": "7", "KC_8": "8",
        "KC_9": "9", "KC_0": "0",

        // Modifiers
        "KC_LEFT_SHIFT": "LShift", "KC_RIGHT_SHIFT": "RShift",
        "KC_LSFT": "LShift", "KC_RSFT": "RShift",
        "KC_LEFT_CTRL": "LCtrl", "KC_RIGHT_CTRL": "RCtrl",
        "KC_LCTL": "LCtrl", "KC_RCTL": "RCtrl",
        "KC_LEFT_ALT": "LAlt", "KC_RIGHT_ALT": "RAlt",
        "KC_LALT": "LAlt", "KC_RALT": "RAlt",
        "KC_LEFT_GUI": "LCmd", "KC_RIGHT_GUI": "RCmd",
        "KC_LGUI": "LCmd", "KC_RGUI": "RCmd",

        // Special keys
        "KC_SPACE": "Space", "KC_SPC": "Space",
        "KC_ENTER": "Enter", "KC_ENT": "Enter",
        "KC_ESCAPE": "Esc", "KC_ESC": "Esc",
        "KC_BACKSPACE": "Bksp", "KC_BSPC": "Bksp",
        "KC_TAB": "Tab",
        "KC_DELETE": "Del", "KC_DEL": "Del",
        "KC_INSERT": "Ins", "KC_INS": "Ins",
        "KC_CAPS_LOCK": "CapsLock", "KC_CAPS": "CapsLock",

        // Navigation
        "KC_UP": "Up", "KC_DOWN": "Down",
        "KC_LEFT": "Left", "KC_RIGHT": "Right",
        "KC_HOME": "Home", "KC_END": "End",
        "KC_PAGE_UP": "PgUp", "KC_PGUP": "PgUp",
        "KC_PAGE_DOWN": "PgDn", "KC_PGDN": "PgDn",

        // Punctuation
        "KC_MINUS": "-", "KC_MINS": "-",
        "KC_EQUAL": "=", "KC_EQL": "=",
        "KC_LEFT_BRACKET": "[", "KC_LBRC": "[",
        "KC_RIGHT_BRACKET": "]", "KC_RBRC": "]",
        "KC_BACKSLASH": "\\", "KC_BSLS": "\\",
        "KC_SEMICOLON": ";", "KC_SCLN": ";",
        "KC_QUOTE": "'", "KC_QUOT": "'",
        "KC_GRAVE": "`", "KC_GRV": "`",
        "KC_COMMA": ",", "KC_COMM": ",",
        "KC_DOT": ".", "KC_SLASH": "/", "KC_SLSH": "/",

        // Function keys
        "KC_F1": "F1", "KC_F2": "F2", "KC_F3": "F3", "KC_F4": "F4",
        "KC_F5": "F5", "KC_F6": "F6", "KC_F7": "F7", "KC_F8": "F8",
        "KC_F9": "F9", "KC_F10": "F10", "KC_F11": "F11", "KC_F12": "F12",

        // Media
        "KC_AUDIO_VOL_UP": "Vol+", "KC_VOLU": "Vol+",
        "KC_AUDIO_VOL_DOWN": "Vol-", "KC_VOLD": "Vol-",
        "KC_AUDIO_MUTE": "Mute", "KC_MUTE": "Mute",
        "KC_MEDIA_PLAY_PAUSE": "Play/Pause", "KC_MPLY": "Play/Pause",
        "KC_MEDIA_NEXT_TRACK": "Next", "KC_MNXT": "Next",
        "KC_MEDIA_PREV_TRACK": "Prev", "KC_MPRV": "Prev",

        // Misc
        "KC_PRINT_SCREEN": "PrtSc", "KC_PSCR": "PrtSc",
        "KC_SCROLL_LOCK": "ScrLk", "KC_SCRL": "ScrLk",
        "KC_PAUSE": "Pause", "KC_PAUS": "Pause",
        "KC_NO": "", "KC_TRANSPARENT": "", "KC_TRNS": "",
    ]
}
