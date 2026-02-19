import Foundation

enum CustomKeybindingParser {
    // Regex to match: vim.keymap.set("n", "<leader>xx", ...)
    // Supports both quoted and table-style mode arguments
    private static let keymapPattern = #/vim\.keymap\.set\(\s*(?:\{[^}]*\}|"([^"]+)")\s*,\s*"([^"]+)"\s*,\s*(?:[^,]+)\s*(?:,\s*\{[^}]*desc\s*=\s*"([^"]+)"[^}]*\})?\s*\)/#

    static func parseKeybindings() -> [Keybinding] {
        let configDir = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent(".config/nvim/lua")

        var results: [Keybinding] = []

        // Parse config/keymaps.lua
        let keymapsFile = configDir.appendingPathComponent("config/keymaps.lua")
        results.append(contentsOf: parseFile(at: keymapsFile))

        // Parse plugins/*.lua
        let pluginsDir = configDir.appendingPathComponent("plugins")
        if let files = try? FileManager.default.contentsOfDirectory(
            at: pluginsDir,
            includingPropertiesForKeys: nil,
            options: [.skipsHiddenFiles]
        ) {
            for file in files where file.pathExtension == "lua" {
                results.append(contentsOf: parseFile(at: file))
            }
        }

        return results
    }

    private static func parseFile(at url: URL) -> [Keybinding] {
        guard let content = try? String(contentsOf: url, encoding: .utf8) else {
            return []
        }
        return parseLuaContent(content, source: url.lastPathComponent)
    }

    static func parseLuaContent(_ content: String, source: String = "custom") -> [Keybinding] {
        var bindings: [Keybinding] = []

        for line in content.components(separatedBy: .newlines) {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            guard trimmed.contains("vim.keymap.set") else { continue }

            if let match = try? keymapPattern.firstMatch(in: trimmed) {
                let mode = match.output.1.map(String.init) ?? "n"
                let keys = String(match.output.2)
                let desc = match.output.3.map(String.init) ?? "Custom: \(keys)"

                bindings.append(Keybinding(
                    keys: keys,
                    description: desc,
                    mode: mode,
                    category: "custom (\(source))"
                ))
            }
        }

        return bindings
    }
}
