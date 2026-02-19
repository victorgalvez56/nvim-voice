import Foundation

final class KeybindingContext {
    private var cachedContext: String?

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

        cachedContext = markdown
        return markdown
    }

    func invalidateCache() {
        cachedContext = nil
    }
}
