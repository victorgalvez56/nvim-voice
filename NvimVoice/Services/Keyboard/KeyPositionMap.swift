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
}
