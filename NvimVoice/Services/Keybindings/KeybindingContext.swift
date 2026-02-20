import Foundation

final class KeybindingContext {
    private var cachedContext: String?
    var keyboardLayout: KeyboardLayout? {
        didSet { invalidateCache() }
    }

    func generateContext() -> String {
        if let cached = cachedContext { return cached }

        var markdown = "# Available Neovim/LazyVim Keybindings\n\n"
        markdown += "Leader key: `<Space>`\n\n"

        // Default LazyVim keybindings by category
        let categories = LazyVimKeybindings.byCategory()
        let sortedCategories = categories.keys.sorted()

        for category in sortedCategories {
            guard let bindings = categories[category] else { continue }
            markdown += "## \(category.capitalized)\n\n"
            markdown += "| Keys | Description | Mode |\n"
            markdown += "|------|-------------|------|\n"
            for binding in bindings {
                markdown += "| `\(binding.keys)` | \(binding.description) | \(binding.mode) |\n"
            }
            markdown += "\n"
        }

        // Custom user keybindings
        let custom = CustomKeybindingParser.parseKeybindings()
        if !custom.isEmpty {
            markdown += "## Custom User Keybindings\n\n"
            markdown += "| Keys | Description | Mode | Source |\n"
            markdown += "|------|-------------|------|--------|\n"
            for binding in custom {
                markdown += "| `\(binding.keys)` | \(binding.description) | \(binding.mode) | \(binding.category) |\n"
            }
            markdown += "\n"
        }

        // Physical keyboard layout
        if let layout = keyboardLayout {
            markdown += generateKeyboardSection(layout)
        }

        cachedContext = markdown
        return markdown
    }

    func invalidateCache() {
        cachedContext = nil
    }

    // MARK: - Keyboard Layout Section

    private func generateKeyboardSection(_ layout: KeyboardLayout) -> String {
        var section = "## Physical Keyboard Layout (\(layout.geometry.displayName) - \"\(layout.title)\")\n\n"

        // Only include Layer 0 (base layer)
        guard let baseLayer = layout.layers.first else { return section }

        section += "| Position | Tap | Hold |\n"
        section += "|----------|-----|------|\n"

        for (index, key) in baseLayer.keys.enumerated() {
            // Skip empty and transparent keys
            if key.isEmpty || key.isTransparent { continue }
            guard key.tap != nil || key.hold != nil || key.holdLayer != nil || key.customLabel != nil else {
                continue
            }

            let position = KeyPositionMap.position(for: index, geometry: layout.geometry)
            let posLabel = position?.shortDescription ?? "key \(index)"

            let tapLabel: String
            if let t = key.tap {
                tapLabel = t.label.isEmpty ? "-" : t.label
            } else if let custom = key.customLabel {
                tapLabel = custom
            } else {
                tapLabel = "-"
            }

            let holdLabel: String
            if let h = key.hold {
                holdLabel = h.label.isEmpty ? "-" : h.label
            } else if let layer = key.holdLayer {
                holdLabel = "Layer \(layer)"
            } else {
                holdLabel = "-"
            }

            section += "| \(posLabel) | \(tapLabel) | \(holdLabel) |\n"
        }
        section += "\n"

        return section
    }
}
