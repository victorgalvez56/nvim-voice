import SwiftUI

struct KeyboardMapView: View {
    let layout: KeyboardLayout
    var layerIndex: Int = 0
    var compact: Bool = false
    var highlights: [Int: [Int]] = [:]  // keyIndex -> [step numbers]

    private var kSize: CGFloat { compact ? 22 : 40 }
    private var kSpacing: CGFloat { compact ? 1 : 3 }
    private var kGap: CGFloat { compact ? 16 : 36 }
    private var fontSize: CGFloat { compact ? 7 : 10 }
    private var cornerRadius: CGFloat { compact ? 3 : 5 }

    private var activeLayer: KeyboardLayer? {
        guard layerIndex >= 0, layerIndex < layout.layers.count else { return nil }
        return layout.layers[layerIndex]
    }

    var body: some View {
        VStack(spacing: compact ? 4 : 8) {
            if !compact {
                Text("\(layout.geometry.displayName) — \"\(layout.title)\"")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            switch layout.geometry {
            case .moonlander:
                moonlanderView
            case .voyager:
                voyagerView
            case .ergodoxEz:
                moonlanderView
            }
        }
    }

    // MARK: - Moonlander (72 keys)

    private var moonlanderView: some View {
        HStack(alignment: .top, spacing: kGap) {
            VStack(alignment: .trailing, spacing: kSpacing) {
                ForEach(0..<4, id: \.self) { row in
                    keyRow(start: row * 7, count: 7)
                }
                HStack(spacing: kSpacing) {
                    keyRow(start: 28, count: 5)
                    Spacer().frame(width: (kSize + kSpacing) * 2 - kSpacing)
                }
                HStack(spacing: kSpacing) {
                    Spacer().frame(width: (kSize + kSpacing) * 4)
                    keyRow(start: 33, count: 3)
                }
            }
            VStack(alignment: .leading, spacing: kSpacing) {
                ForEach(0..<4, id: \.self) { row in
                    keyRow(start: 36 + row * 7, count: 7)
                }
                HStack(spacing: kSpacing) {
                    Spacer().frame(width: (kSize + kSpacing) * 2 - kSpacing)
                    keyRow(start: 36 + 28, count: 5)
                }
                HStack(spacing: kSpacing) {
                    keyRow(start: 36 + 33, count: 3)
                    Spacer().frame(width: (kSize + kSpacing) * 4)
                }
            }
        }
    }

    // MARK: - Voyager (52 keys)

    private var voyagerView: some View {
        HStack(alignment: .top, spacing: kGap) {
            VStack(alignment: .trailing, spacing: kSpacing) {
                ForEach(0..<4, id: \.self) { row in
                    keyRow(start: row * 6, count: 6)
                }
                HStack(spacing: kSpacing) {
                    Spacer().frame(width: (kSize + kSpacing) * 4)
                    keyRow(start: 24, count: 2)
                }
            }
            VStack(alignment: .leading, spacing: kSpacing) {
                ForEach(0..<4, id: \.self) { row in
                    keyRow(start: 26 + row * 6, count: 6)
                }
                HStack(spacing: kSpacing) {
                    keyRow(start: 26 + 24, count: 2)
                    Spacer().frame(width: (kSize + kSpacing) * 4)
                }
            }
        }
    }

    // MARK: - Key rendering

    private func keyRow(start: Int, count: Int) -> some View {
        HStack(spacing: kSpacing) {
            ForEach(0..<count, id: \.self) { i in
                keyView(index: start + i)
            }
        }
    }

    private func keyView(index: Int) -> some View {
        let label = keyLabel(at: index)
        let style = keyStyle(at: index)
        let steps = highlights[index]

        return ZStack(alignment: .topTrailing) {
            Text(label)
                .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: kSize, height: kSize)
                .foregroundStyle(style.foreground)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(style.background)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(style.border, lineWidth: steps != nil ? 1.5 : 0.5)
                )

            if let steps = steps {
                Text(steps.map { "\($0)" }.joined())
                    .font(.system(size: compact ? 6 : 7, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 2)
                    .background(Capsule().fill(.orange))
                    .offset(x: 3, y: -3)
            }
        }
    }

    // MARK: - Key data

    private func keyAt(_ index: Int) -> KeyAction? {
        guard let layer = activeLayer, index < layer.keys.count else { return nil }
        return layer.keys[index]
    }

    private func keyLabel(at index: Int) -> String {
        guard let key = keyAt(index) else { return "" }

        if key.isTransparent { return "\u{25BD}" }  // ▽ = transparent/pass-through
        if let tap = key.tap { return tap.label }
        if let custom = key.customLabel, !custom.isEmpty { return custom }
        if let hold = key.hold { return hold.label }
        if let hl = key.holdLayer { return "L\(hl)" }
        return ""
    }

    private struct KeyStyle {
        let foreground: Color
        let background: Color
        let border: Color
    }

    private func keyStyle(at index: Int) -> KeyStyle {
        let isHighlighted = highlights[index] != nil

        guard let key = keyAt(index) else {
            return KeyStyle(foreground: .clear, background: .gray.opacity(0.05), border: .gray.opacity(0.1))
        }

        if isHighlighted {
            return KeyStyle(foreground: .white, background: .orange.opacity(0.7), border: .orange)
        }

        // Transparent key
        if key.isTransparent {
            return KeyStyle(foreground: .secondary.opacity(0.3), background: .gray.opacity(0.03), border: .gray.opacity(0.1))
        }

        // Empty key
        if key.isEmpty || (key.tap == nil && key.hold == nil && key.holdLayer == nil) {
            return KeyStyle(foreground: .clear, background: .gray.opacity(0.05), border: .gray.opacity(0.15))
        }

        // Modifier / hold-only
        if key.tap == nil && (key.hold != nil || key.holdLayer != nil) {
            return KeyStyle(foreground: .green, background: .green.opacity(0.15), border: .green.opacity(0.4))
        }

        // Dual function (tap + hold)
        if key.hold != nil || key.holdLayer != nil {
            return KeyStyle(foreground: .primary, background: .blue.opacity(0.1), border: .blue.opacity(0.3))
        }

        // Regular
        let dimmed = compact && !highlights.isEmpty
        return KeyStyle(
            foreground: dimmed ? .primary.opacity(0.3) : .primary,
            background: dimmed ? .secondary.opacity(0.03) : .secondary.opacity(0.1),
            border: dimmed ? .secondary.opacity(0.1) : .secondary.opacity(0.3)
        )
    }
}

// MARK: - Key Sequence → Highlight Indices

extension KeyboardMapView {
    static func highlightsFromSequence(_ sequence: String, layout: KeyboardLayout) -> [Int: [Int]] {
        let steps = parseSequence(sequence)
        guard let layer = layout.layers.first else { return [:] }

        var labelToIndex: [String: Int] = [:]
        for (i, key) in layer.keys.enumerated() {
            let label: String
            if let tap = key.tap {
                label = tap.label
            } else if let hold = key.hold {
                label = hold.label
            } else {
                continue
            }
            guard !label.isEmpty else { continue }
            if labelToIndex[label] == nil {
                labelToIndex[label] = i
            }
        }

        var result: [Int: [Int]] = [:]
        for (step, label) in steps {
            if let index = labelToIndex[label] {
                result[index, default: []].append(step)
            }
        }
        return result
    }

    private static func parseSequence(_ sequence: String) -> [(step: Int, label: String)] {
        var result: [(Int, String)] = []
        var step = 1
        var i = sequence.startIndex

        while i < sequence.endIndex {
            if sequence[i] == "<" {
                if let close = sequence[i...].firstIndex(of: ">") {
                    let tag = String(sequence[sequence.index(after: i)..<close]).lowercased()
                    if let label = tagToLabel(tag) {
                        result.append((step, label))
                        step += 1
                    }
                    i = sequence.index(after: close)
                } else {
                    i = sequence.index(after: i)
                }
            } else if sequence[i] == ":" {
                i = sequence.index(after: i)
            } else {
                let char = String(sequence[i]).uppercased()
                result.append((step, char))
                step += 1
                i = sequence.index(after: i)
            }
        }
        return result
    }

    private static func tagToLabel(_ tag: String) -> String? {
        switch tag {
        case "leader", "space": return "Space"
        case "cr", "enter", "return": return "Enter"
        case "esc", "escape": return "Esc"
        case "tab": return "Tab"
        case "bs", "backspace": return "Bksp"
        case "del", "delete": return "Del"
        default:
            if tag.count == 3 && tag.dropLast(1).hasSuffix("-") {
                return String(tag.last!).uppercased()
            }
            return nil
        }
    }
}
