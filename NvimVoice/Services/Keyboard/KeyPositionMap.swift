import Foundation

enum KeyPositionMap {
    static func position(for index: Int, geometry: KeyboardGeometry) -> PhysicalKeyPosition? {
        let map: [PhysicalKeyPosition]
        switch geometry {
        case .moonlander:
            map = moonlanderPositions
        case .voyager:
            map = voyagerPositions
        case .ergodoxEz:
            map = ergodoxPositions
        case .standard:
            map = standardPositions
        }
        guard index >= 0, index < map.count else { return nil }
        return map[index]
    }

    // MARK: - Moonlander (72 keys)
    // Left half: indices 0-35, Right half: 36-71
    // Layout per half: 7+7+7+7+5 = 33 main keys + 3 thumb keys = 36 keys
    // Row 0 (number): 7 keys — pinky(0), pinky(1), ring(2), middle(3), index(4), index(5), index(6)
    // Row 1 (top):    7 keys — same finger pattern
    // Row 2 (home):   7 keys — same finger pattern
    // Row 3 (bottom): 7 keys — same finger pattern
    // Row 4 (func):   5 keys — pinky(0), pinky(1), ring(2), middle(3), index(4)
    // Thumb cluster:  3 keys — thumb(0), thumb(1), thumb(2)

    static let moonlanderPositions: [PhysicalKeyPosition] = {
        var positions: [PhysicalKeyPosition] = []

        for hand in [Hand.left, Hand.right] {
            // Rows 0-3: 7 keys each
            let mainRows: [RowName] = [.numberRow, .topRow, .homeRow, .bottomRow]
            for row in mainRows {
                for col in 0..<7 {
                    let finger: FingerName
                    switch col {
                    case 0, 1: finger = .pinky
                    case 2:    finger = .ring
                    case 3:    finger = .middle
                    default:   finger = .index // 4, 5, 6
                    }
                    positions.append(PhysicalKeyPosition(hand: hand, finger: finger, row: row))
                }
            }
            // Row 4 (function): 5 keys
            for col in 0..<5 {
                let finger: FingerName
                switch col {
                case 0, 1: finger = .pinky
                case 2:    finger = .ring
                case 3:    finger = .middle
                default:   finger = .index
                }
                positions.append(PhysicalKeyPosition(hand: hand, finger: finger, row: .functionRow))
            }
            // Thumb cluster: 3 keys
            for _ in 0..<3 {
                positions.append(PhysicalKeyPosition(hand: hand, finger: .thumb, row: .thumbCluster))
            }
        }
        return positions
    }()

    // MARK: - Voyager (52 keys)
    // Left half: indices 0-25, Right half: 26-51
    // Layout per half: 6+6+6+6 = 24 main keys + 2 thumb keys = 26 keys
    // Row 0 (number): 6 keys — pinky(0), ring(1), middle(2), index(3), index(4), index(5)
    // Row 1 (top):    6 keys — same
    // Row 2 (home):   6 keys — same
    // Row 3 (bottom): 6 keys — same
    // Thumb: 2 keys

    static let voyagerPositions: [PhysicalKeyPosition] = {
        var positions: [PhysicalKeyPosition] = []

        for hand in [Hand.left, Hand.right] {
            let rows: [RowName] = [.numberRow, .topRow, .homeRow, .bottomRow]
            for row in rows {
                for col in 0..<6 {
                    let finger: FingerName
                    switch col {
                    case 0:    finger = .pinky
                    case 1:    finger = .ring
                    case 2:    finger = .middle
                    default:   finger = .index // 3, 4, 5
                    }
                    positions.append(PhysicalKeyPosition(hand: hand, finger: finger, row: row))
                }
            }
            // Thumb: 2 keys
            for _ in 0..<2 {
                positions.append(PhysicalKeyPosition(hand: hand, finger: .thumb, row: .thumbCluster))
            }
        }
        return positions
    }()

    // MARK: - ErgoDox EZ (76 keys)
    // Left half: indices 0-37, Right half: 38-75
    // Layout per half: 7+7+7+7+5 = 33 main keys + 5 thumb keys = 38 keys (similar to Moonlander but larger thumb cluster)

    static let ergodoxPositions: [PhysicalKeyPosition] = {
        var positions: [PhysicalKeyPosition] = []

        for hand in [Hand.left, Hand.right] {
            let mainRows: [RowName] = [.numberRow, .topRow, .homeRow, .bottomRow]
            for row in mainRows {
                for col in 0..<7 {
                    let finger: FingerName
                    switch col {
                    case 0, 1: finger = .pinky
                    case 2:    finger = .ring
                    case 3:    finger = .middle
                    default:   finger = .index
                    }
                    positions.append(PhysicalKeyPosition(hand: hand, finger: finger, row: row))
                }
            }
            // Function row: 5 keys
            for col in 0..<5 {
                let finger: FingerName
                switch col {
                case 0, 1: finger = .pinky
                case 2:    finger = .ring
                case 3:    finger = .middle
                default:   finger = .index
                }
                positions.append(PhysicalKeyPosition(hand: hand, finger: finger, row: .functionRow))
            }
            // Thumb cluster: 5 keys (larger than Moonlander)
            for _ in 0..<5 {
                positions.append(PhysicalKeyPosition(hand: hand, finger: .thumb, row: .thumbCluster))
            }
        }
        return positions
    }()

    // MARK: - Standard ANSI (61 keys)
    // Row 0 (14): Esc 1 2 3 4 5 6 | 7 8 9 0 - = Bksp
    // Row 1 (14): Tab Q W E R T | Y U I O P [ ] \
    // Row 2 (13): Caps A S D F G | H J K L ; ' Enter
    // Row 3 (12): LShift Z X C V B | N M , . / RShift
    // Row 4  (8): LCtrl LAlt LCmd | Space | RCmd RAlt Left Right
    // Left/right split at T/Y boundary (column 6 on rows 0-1, column 5-6 on rows 2-3)

    static let standardPositions: [PhysicalKeyPosition] = {
        typealias P = PhysicalKeyPosition
        var pos: [P] = []

        // Row 0 — number row (14 keys)
        // Esc(L pinky), 1(L pinky), 2(L ring), 3(L mid), 4(L idx), 5(L idx), 6(L idx)
        // 7(R idx), 8(R idx), 9(R mid), 0(R ring), -(R pinky), =(R pinky), Bksp(R pinky)
        pos.append(P(hand: .left,  finger: .pinky,  row: .numberRow))  // Esc
        pos.append(P(hand: .left,  finger: .pinky,  row: .numberRow))  // 1
        pos.append(P(hand: .left,  finger: .ring,   row: .numberRow))  // 2
        pos.append(P(hand: .left,  finger: .middle, row: .numberRow))  // 3
        pos.append(P(hand: .left,  finger: .index,  row: .numberRow))  // 4
        pos.append(P(hand: .left,  finger: .index,  row: .numberRow))  // 5
        pos.append(P(hand: .left,  finger: .index,  row: .numberRow))  // 6
        pos.append(P(hand: .right, finger: .index,  row: .numberRow))  // 7
        pos.append(P(hand: .right, finger: .index,  row: .numberRow))  // 8
        pos.append(P(hand: .right, finger: .middle, row: .numberRow))  // 9
        pos.append(P(hand: .right, finger: .ring,   row: .numberRow))  // 0
        pos.append(P(hand: .right, finger: .pinky,  row: .numberRow))  // -
        pos.append(P(hand: .right, finger: .pinky,  row: .numberRow))  // =
        pos.append(P(hand: .right, finger: .pinky,  row: .numberRow))  // Bksp

        // Row 1 — top row (14 keys)
        pos.append(P(hand: .left,  finger: .pinky,  row: .topRow))  // Tab
        pos.append(P(hand: .left,  finger: .pinky,  row: .topRow))  // Q
        pos.append(P(hand: .left,  finger: .ring,   row: .topRow))  // W
        pos.append(P(hand: .left,  finger: .middle, row: .topRow))  // E
        pos.append(P(hand: .left,  finger: .index,  row: .topRow))  // R
        pos.append(P(hand: .left,  finger: .index,  row: .topRow))  // T
        pos.append(P(hand: .right, finger: .index,  row: .topRow))  // Y
        pos.append(P(hand: .right, finger: .index,  row: .topRow))  // U
        pos.append(P(hand: .right, finger: .middle, row: .topRow))  // I
        pos.append(P(hand: .right, finger: .ring,   row: .topRow))  // O
        pos.append(P(hand: .right, finger: .pinky,  row: .topRow))  // P
        pos.append(P(hand: .right, finger: .pinky,  row: .topRow))  // [
        pos.append(P(hand: .right, finger: .pinky,  row: .topRow))  // ]
        pos.append(P(hand: .right, finger: .pinky,  row: .topRow))  // backslash

        // Row 2 — home row (13 keys)
        pos.append(P(hand: .left,  finger: .pinky,  row: .homeRow))  // Caps
        pos.append(P(hand: .left,  finger: .pinky,  row: .homeRow))  // A
        pos.append(P(hand: .left,  finger: .ring,   row: .homeRow))  // S
        pos.append(P(hand: .left,  finger: .middle, row: .homeRow))  // D
        pos.append(P(hand: .left,  finger: .index,  row: .homeRow))  // F
        pos.append(P(hand: .left,  finger: .index,  row: .homeRow))  // G
        pos.append(P(hand: .right, finger: .index,  row: .homeRow))  // H
        pos.append(P(hand: .right, finger: .index,  row: .homeRow))  // J
        pos.append(P(hand: .right, finger: .middle, row: .homeRow))  // K
        pos.append(P(hand: .right, finger: .ring,   row: .homeRow))  // L
        pos.append(P(hand: .right, finger: .pinky,  row: .homeRow))  // ;
        pos.append(P(hand: .right, finger: .pinky,  row: .homeRow))  // '
        pos.append(P(hand: .right, finger: .pinky,  row: .homeRow))  // Enter

        // Row 3 — bottom row (12 keys)
        pos.append(P(hand: .left,  finger: .pinky,  row: .bottomRow))  // LShift
        pos.append(P(hand: .left,  finger: .pinky,  row: .bottomRow))  // Z
        pos.append(P(hand: .left,  finger: .ring,   row: .bottomRow))  // X
        pos.append(P(hand: .left,  finger: .middle, row: .bottomRow))  // C
        pos.append(P(hand: .left,  finger: .index,  row: .bottomRow))  // V
        pos.append(P(hand: .left,  finger: .index,  row: .bottomRow))  // B
        pos.append(P(hand: .right, finger: .index,  row: .bottomRow))  // N
        pos.append(P(hand: .right, finger: .index,  row: .bottomRow))  // M
        pos.append(P(hand: .right, finger: .middle, row: .bottomRow))  // ,
        pos.append(P(hand: .right, finger: .ring,   row: .bottomRow))  // .
        pos.append(P(hand: .right, finger: .pinky,  row: .bottomRow))  // /
        pos.append(P(hand: .right, finger: .pinky,  row: .bottomRow))  // RShift

        // Row 4 — modifier/space row (8 keys)
        pos.append(P(hand: .left,  finger: .pinky,  row: .bottomRow))  // LCtrl
        pos.append(P(hand: .left,  finger: .ring,   row: .bottomRow))  // LAlt
        pos.append(P(hand: .left,  finger: .thumb,  row: .bottomRow))  // LCmd
        pos.append(P(hand: .left,  finger: .thumb,  row: .bottomRow))  // Space
        pos.append(P(hand: .right, finger: .thumb,  row: .bottomRow))  // RCmd
        pos.append(P(hand: .right, finger: .ring,   row: .bottomRow))  // RAlt
        pos.append(P(hand: .right, finger: .pinky,  row: .bottomRow))  // Left
        pos.append(P(hand: .right, finger: .pinky,  row: .bottomRow))  // Right

        return pos
    }()
}
