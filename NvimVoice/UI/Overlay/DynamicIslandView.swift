import SwiftUI

struct DynamicIslandView: View {
    var state: IslandState
    var keyboardLayout: KeyboardLayout?
    var pillTopOffset: CGFloat

    private let compactWidth: CGFloat = 200
    private let compactHeight: CGFloat = 36
    private let compactRadius: CGFloat = 18
    private let expandedWidth: CGFloat = 700
    private let expandedRadius: CGFloat = 22

    private let springAnimation: Animation = .spring(duration: 0.4, bounce: 0.25)

    private var isVisible: Bool {
        state.phase != .hidden
    }

    private var isExpanded: Bool {
        if case .expanded = state.phase { return true }
        return false
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: pillTopOffset)

            pillContent
                .frame(width: isExpanded ? expandedWidth : compactWidth)
                .fixedSize(horizontal: false, vertical: true)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: isExpanded ? expandedRadius : compactRadius, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: isExpanded ? expandedRadius : compactRadius, style: .continuous)
                        .strokeBorder(.white.opacity(0.15), lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.3), radius: 20, y: 5)
                .scaleEffect(isVisible ? 1 : 0.5)
                .opacity(isVisible ? 1 : 0)
                .animation(springAnimation, value: state.phase)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var pillContent: some View {
        switch state.phase {
        case .hidden:
            Color.clear.frame(height: compactHeight)
        case .recording:
            compactRecordingView
        case .processing:
            compactProcessingView
        case .expanded(let instruction):
            expandedView(instruction)
        case .collapsing(let instruction):
            compactCollapsingView(instruction)
        }
    }

    // MARK: - Compact States

    private var compactRecordingView: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(.red)
                .frame(width: 8, height: 8)
            Text("Recording...")
                .font(.system(.callout, design: .rounded, weight: .medium))
                .foregroundStyle(.primary)
        }
        .frame(height: compactHeight)
        .transition(.opacity)
    }

    private var compactProcessingView: some View {
        HStack(spacing: 8) {
            ProgressView()
                .controlSize(.small)
            Text("Processing...")
                .font(.system(.callout, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .frame(height: compactHeight)
        .transition(.opacity)
    }

    private func compactCollapsingView(_ instruction: NvimInstruction) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.system(size: 14))
            Text(instruction.keySequence)
                .font(.system(.callout, design: .monospaced, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .frame(height: compactHeight)
        .transition(.opacity)
    }

    // MARK: - Expanded State

    private func expandedView(_ instruction: NvimInstruction) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(instruction.keySequence)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.primary)

            if let physical = instruction.physicalKeys {
                Text(physical)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.blue)
                    .lineLimit(2)
            }

            if let layout = keyboardLayout {
                let highlights = KeyboardMapView.highlightsFromSequence(
                    instruction.keySequence, layout: layout
                )
                KeyboardMapView(layout: layout, compact: false, highlights: highlights)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            Text(instruction.explanation)
                .font(.system(.callout))
                .foregroundStyle(.secondary)

            if !instruction.steps.isEmpty {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(instruction.steps.enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top, spacing: 6) {
                            Text("\(index + 1).")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.tertiary)
                            Text(step)
                                .font(.system(.caption))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            if let alts = instruction.alternativeKeys, !alts.isEmpty {
                HStack(spacing: 4) {
                    Text("Alt:")
                        .font(.system(.caption2))
                        .foregroundStyle(.tertiary)
                    ForEach(alts, id: \.self) { alt in
                        Text(alt)
                            .font(.system(.caption2, design: .monospaced))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(.quaternary, in: RoundedRectangle(cornerRadius: 4))
                    }
                }
            }
        }
        .padding(16)
        .transition(.opacity)
    }
}
