import SwiftUI

struct OverlayContentView: View {
    let state: OverlayState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch state {
            case .processing:
                processingView
            case .result(let instruction):
                resultView(instruction)
            }
        }
        .padding(16)
        .frame(width: 360)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(.white.opacity(0.1), lineWidth: 1)
        )
    }

    private var processingView: some View {
        HStack(spacing: 10) {
            ProgressView()
                .controlSize(.small)
            Text("Processing...")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }

    private func resultView(_ instruction: NvimInstruction) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Key sequence (big, prominent)
            Text(instruction.keySequence)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundStyle(.primary)

            // Physical key positions
            if let physical = instruction.physicalKeys {
                Text(physical)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.blue)
                    .lineLimit(2)
            }

            // Explanation
            Text(instruction.explanation)
                .font(.system(.callout))
                .foregroundStyle(.secondary)
                .lineLimit(3)

            // Steps
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

            // Alternatives
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
    }
}

enum OverlayState {
    case processing
    case result(NvimInstruction)
}
