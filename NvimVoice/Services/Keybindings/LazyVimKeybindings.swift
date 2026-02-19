import Foundation

struct Keybinding {
    let keys: String
    let description: String
    let mode: String // n, v, i, x, t, etc.
    let category: String
}

enum LazyVimKeybindings {
    static let leader = "<Space>"

    static let defaults: [Keybinding] = [
        // MARK: - General
        Keybinding(keys: "<leader>l", description: "Open Lazy.nvim panel", mode: "n", category: "general"),
        Keybinding(keys: "<leader>qq", description: "Quit all", mode: "n", category: "general"),
        Keybinding(keys: "<leader>fn", description: "New file", mode: "n", category: "general"),
        Keybinding(keys: "<leader>xl", description: "Location list", mode: "n", category: "general"),
        Keybinding(keys: "<leader>xq", description: "Quickfix list", mode: "n", category: "general"),
        Keybinding(keys: "<leader>K", description: "Keywordprg", mode: "n", category: "general"),
        Keybinding(keys: "<leader>ur", description: "Redraw / clear hlsearch / diff update", mode: "n", category: "general"),

        // MARK: - Navigation / Movement
        Keybinding(keys: "h", description: "Move left", mode: "n", category: "navigation"),
        Keybinding(keys: "j", description: "Move down", mode: "n", category: "navigation"),
        Keybinding(keys: "k", description: "Move up", mode: "n", category: "navigation"),
        Keybinding(keys: "l", description: "Move right", mode: "n", category: "navigation"),
        Keybinding(keys: "w", description: "Move to next word", mode: "n", category: "navigation"),
        Keybinding(keys: "b", description: "Move to previous word", mode: "n", category: "navigation"),
        Keybinding(keys: "e", description: "Move to end of word", mode: "n", category: "navigation"),
        Keybinding(keys: "gg", description: "Go to first line", mode: "n", category: "navigation"),
        Keybinding(keys: "G", description: "Go to last line", mode: "n", category: "navigation"),
        Keybinding(keys: "<C-d>", description: "Scroll down half page", mode: "n", category: "navigation"),
        Keybinding(keys: "<C-u>", description: "Scroll up half page", mode: "n", category: "navigation"),
        Keybinding(keys: "%", description: "Jump to matching bracket", mode: "n", category: "navigation"),
        Keybinding(keys: "{", description: "Move to previous paragraph", mode: "n", category: "navigation"),
        Keybinding(keys: "}", description: "Move to next paragraph", mode: "n", category: "navigation"),
        Keybinding(keys: "0", description: "Go to beginning of line", mode: "n", category: "navigation"),
        Keybinding(keys: "$", description: "Go to end of line", mode: "n", category: "navigation"),
        Keybinding(keys: "^", description: "Go to first non-blank character", mode: "n", category: "navigation"),

        // MARK: - Windows
        Keybinding(keys: "<leader>w-", description: "Split window below", mode: "n", category: "windows"),
        Keybinding(keys: "<leader>w|", description: "Split window right", mode: "n", category: "windows"),
        Keybinding(keys: "<leader>wd", description: "Delete window", mode: "n", category: "windows"),
        Keybinding(keys: "<leader>wm", description: "Toggle maximize window", mode: "n", category: "windows"),
        Keybinding(keys: "<C-h>", description: "Go to left window", mode: "n", category: "windows"),
        Keybinding(keys: "<C-j>", description: "Go to lower window", mode: "n", category: "windows"),
        Keybinding(keys: "<C-k>", description: "Go to upper window", mode: "n", category: "windows"),
        Keybinding(keys: "<C-l>", description: "Go to right window", mode: "n", category: "windows"),
        Keybinding(keys: "<C-Up>", description: "Increase window height", mode: "n", category: "windows"),
        Keybinding(keys: "<C-Down>", description: "Decrease window height", mode: "n", category: "windows"),
        Keybinding(keys: "<C-Left>", description: "Decrease window width", mode: "n", category: "windows"),
        Keybinding(keys: "<C-Right>", description: "Increase window width", mode: "n", category: "windows"),

        // MARK: - Buffers
        Keybinding(keys: "<leader>bb", description: "Switch to other buffer", mode: "n", category: "buffers"),
        Keybinding(keys: "<leader>bd", description: "Delete buffer", mode: "n", category: "buffers"),
        Keybinding(keys: "<leader>bD", description: "Delete buffer and window", mode: "n", category: "buffers"),
        Keybinding(keys: "<leader>bo", description: "Delete other buffers", mode: "n", category: "buffers"),
        Keybinding(keys: "<leader>bp", description: "Toggle pin buffer", mode: "n", category: "buffers"),
        Keybinding(keys: "<leader>bP", description: "Delete non-pinned buffers", mode: "n", category: "buffers"),
        Keybinding(keys: "<S-h>", description: "Previous buffer", mode: "n", category: "buffers"),
        Keybinding(keys: "<S-l>", description: "Next buffer", mode: "n", category: "buffers"),
        Keybinding(keys: "[b", description: "Previous buffer", mode: "n", category: "buffers"),
        Keybinding(keys: "]b", description: "Next buffer", mode: "n", category: "buffers"),

        // MARK: - Tabs
        Keybinding(keys: "<leader><tab>l", description: "Last tab", mode: "n", category: "tabs"),
        Keybinding(keys: "<leader><tab>o", description: "Close other tabs", mode: "n", category: "tabs"),
        Keybinding(keys: "<leader><tab>f", description: "First tab", mode: "n", category: "tabs"),
        Keybinding(keys: "<leader><tab><tab>", description: "New tab", mode: "n", category: "tabs"),
        Keybinding(keys: "<leader><tab>]", description: "Next tab", mode: "n", category: "tabs"),
        Keybinding(keys: "<leader><tab>d", description: "Close tab", mode: "n", category: "tabs"),
        Keybinding(keys: "<leader><tab>[", description: "Previous tab", mode: "n", category: "tabs"),

        // MARK: - Find / Search (Telescope)
        Keybinding(keys: "<leader><space>", description: "Find files (root dir)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>,", description: "Switch buffer", mode: "n", category: "search"),
        Keybinding(keys: "<leader>/", description: "Grep (root dir)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>:", description: "Command history", mode: "n", category: "search"),
        Keybinding(keys: "<leader>fb", description: "Buffers", mode: "n", category: "search"),
        Keybinding(keys: "<leader>fc", description: "Find config file", mode: "n", category: "search"),
        Keybinding(keys: "<leader>ff", description: "Find files (root dir)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>fF", description: "Find files (cwd)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>fg", description: "Find files (git files)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>fr", description: "Recent", mode: "n", category: "search"),
        Keybinding(keys: "<leader>fR", description: "Recent (cwd)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sa", description: "Auto commands", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sb", description: "Buffer", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sc", description: "Command history", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sC", description: "Commands", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sd", description: "Document diagnostics", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sD", description: "Workspace diagnostics", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sg", description: "Grep (root dir)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sG", description: "Grep (cwd)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sh", description: "Help pages", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sH", description: "Search highlight groups", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sj", description: "Jumplist", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sk", description: "Key maps", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sl", description: "Location list", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sM", description: "Man pages", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sm", description: "Jump to mark", mode: "n", category: "search"),
        Keybinding(keys: "<leader>so", description: "Options", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sR", description: "Resume", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sq", description: "Quickfix list", mode: "n", category: "search"),
        Keybinding(keys: "<leader>ss", description: "Go to symbol", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sS", description: "Go to symbol (workspace)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sw", description: "Word (root dir)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sW", description: "Word (cwd)", mode: "n", category: "search"),
        Keybinding(keys: "<leader>sw", description: "Selection (root dir)", mode: "v", category: "search"),
        Keybinding(keys: "<leader>sW", description: "Selection (cwd)", mode: "v", category: "search"),
        Keybinding(keys: "<leader>uC", description: "Colorscheme with preview", mode: "n", category: "search"),

        // MARK: - LSP
        Keybinding(keys: "gd", description: "Go to definition", mode: "n", category: "lsp"),
        Keybinding(keys: "gr", description: "References", mode: "n", category: "lsp"),
        Keybinding(keys: "gD", description: "Go to declaration", mode: "n", category: "lsp"),
        Keybinding(keys: "gI", description: "Go to implementation", mode: "n", category: "lsp"),
        Keybinding(keys: "gy", description: "Go to type definition", mode: "n", category: "lsp"),
        Keybinding(keys: "K", description: "Hover", mode: "n", category: "lsp"),
        Keybinding(keys: "gK", description: "Signature help", mode: "n", category: "lsp"),
        Keybinding(keys: "<leader>ca", description: "Code action", mode: "n,v", category: "lsp"),
        Keybinding(keys: "<leader>cc", description: "Run codelens", mode: "n,v", category: "lsp"),
        Keybinding(keys: "<leader>cC", description: "Refresh & display codelens", mode: "n", category: "lsp"),
        Keybinding(keys: "<leader>cr", description: "Rename", mode: "n", category: "lsp"),
        Keybinding(keys: "<leader>cA", description: "Source action", mode: "n", category: "lsp"),
        Keybinding(keys: "<leader>cl", description: "Lsp info", mode: "n", category: "lsp"),
        Keybinding(keys: "]d", description: "Next diagnostic", mode: "n", category: "lsp"),
        Keybinding(keys: "[d", description: "Previous diagnostic", mode: "n", category: "lsp"),
        Keybinding(keys: "]e", description: "Next error", mode: "n", category: "lsp"),
        Keybinding(keys: "[e", description: "Previous error", mode: "n", category: "lsp"),
        Keybinding(keys: "]w", description: "Next warning", mode: "n", category: "lsp"),
        Keybinding(keys: "[w", description: "Previous warning", mode: "n", category: "lsp"),
        Keybinding(keys: "<leader>cf", description: "Format", mode: "n,v", category: "lsp"),

        // MARK: - File Explorer (Neo-tree)
        Keybinding(keys: "<leader>e", description: "Explorer NeoTree (root dir)", mode: "n", category: "explorer"),
        Keybinding(keys: "<leader>E", description: "Explorer NeoTree (cwd)", mode: "n", category: "explorer"),
        Keybinding(keys: "<leader>fe", description: "Explorer NeoTree (root dir)", mode: "n", category: "explorer"),
        Keybinding(keys: "<leader>fE", description: "Explorer NeoTree (cwd)", mode: "n", category: "explorer"),
        Keybinding(keys: "<leader>ge", description: "Git explorer", mode: "n", category: "explorer"),
        Keybinding(keys: "<leader>be", description: "Buffer explorer", mode: "n", category: "explorer"),

        // MARK: - Git
        Keybinding(keys: "<leader>gg", description: "Lazygit (root dir)", mode: "n", category: "git"),
        Keybinding(keys: "<leader>gG", description: "Lazygit (cwd)", mode: "n", category: "git"),
        Keybinding(keys: "<leader>gf", description: "Lazygit current file history", mode: "n", category: "git"),
        Keybinding(keys: "<leader>gl", description: "Lazygit log", mode: "n", category: "git"),
        Keybinding(keys: "<leader>gb", description: "Git blame line", mode: "n", category: "git"),
        Keybinding(keys: "<leader>gB", description: "Git browse", mode: "n,v", category: "git"),
        Keybinding(keys: "]h", description: "Next hunk", mode: "n", category: "git"),
        Keybinding(keys: "[h", description: "Previous hunk", mode: "n", category: "git"),
        Keybinding(keys: "<leader>ghs", description: "Stage hunk", mode: "n,v", category: "git"),
        Keybinding(keys: "<leader>ghr", description: "Reset hunk", mode: "n,v", category: "git"),
        Keybinding(keys: "<leader>ghS", description: "Stage buffer", mode: "n", category: "git"),
        Keybinding(keys: "<leader>ghR", description: "Reset buffer", mode: "n", category: "git"),
        Keybinding(keys: "<leader>ghp", description: "Preview hunk inline", mode: "n", category: "git"),
        Keybinding(keys: "<leader>ghb", description: "Blame line", mode: "n", category: "git"),
        Keybinding(keys: "<leader>ghd", description: "Diff this", mode: "n", category: "git"),
        Keybinding(keys: "<leader>ghD", description: "Diff this ~", mode: "n", category: "git"),

        // MARK: - Flash (Navigation)
        Keybinding(keys: "s", description: "Flash", mode: "n,x,o", category: "flash"),
        Keybinding(keys: "S", description: "Flash treesitter", mode: "n,x,o", category: "flash"),
        Keybinding(keys: "r", description: "Remote flash", mode: "o", category: "flash"),
        Keybinding(keys: "R", description: "Treesitter search", mode: "o,x", category: "flash"),
        Keybinding(keys: "<C-s>", description: "Toggle flash search", mode: "c", category: "flash"),

        // MARK: - Terminal
        Keybinding(keys: "<leader>ft", description: "Terminal (root dir)", mode: "n", category: "terminal"),
        Keybinding(keys: "<leader>fT", description: "Terminal (cwd)", mode: "n", category: "terminal"),
        Keybinding(keys: "<C-/>", description: "Terminal (root dir)", mode: "n", category: "terminal"),
        Keybinding(keys: "<C-_>", description: "which_key_ignore", mode: "n,t", category: "terminal"),
        Keybinding(keys: "<esc><esc>", description: "Enter normal mode", mode: "t", category: "terminal"),
        Keybinding(keys: "<C-/>", description: "Hide terminal", mode: "t", category: "terminal"),

        // MARK: - Toggle UI
        Keybinding(keys: "<leader>uf", description: "Toggle auto format (global)", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uF", description: "Toggle auto format (buffer)", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>us", description: "Toggle spelling", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uw", description: "Toggle word wrap", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uL", description: "Toggle relative number", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>ul", description: "Toggle line numbers", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>ud", description: "Toggle diagnostics", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uc", description: "Toggle conceal", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uT", description: "Toggle treesitter", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>ub", description: "Toggle background", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uh", description: "Toggle inlay hints", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>ug", description: "Toggle indent guides", mode: "n", category: "ui"),
        Keybinding(keys: "<leader>uI", description: "Inspect pos", mode: "n", category: "ui"),

        // MARK: - Editing
        Keybinding(keys: "i", description: "Insert before cursor", mode: "n", category: "editing"),
        Keybinding(keys: "a", description: "Insert after cursor", mode: "n", category: "editing"),
        Keybinding(keys: "A", description: "Insert at end of line", mode: "n", category: "editing"),
        Keybinding(keys: "I", description: "Insert at beginning of line", mode: "n", category: "editing"),
        Keybinding(keys: "o", description: "Open line below", mode: "n", category: "editing"),
        Keybinding(keys: "O", description: "Open line above", mode: "n", category: "editing"),
        Keybinding(keys: "dd", description: "Delete line", mode: "n", category: "editing"),
        Keybinding(keys: "yy", description: "Yank line", mode: "n", category: "editing"),
        Keybinding(keys: "p", description: "Paste after cursor", mode: "n", category: "editing"),
        Keybinding(keys: "P", description: "Paste before cursor", mode: "n", category: "editing"),
        Keybinding(keys: "u", description: "Undo", mode: "n", category: "editing"),
        Keybinding(keys: "<C-r>", description: "Redo", mode: "n", category: "editing"),
        Keybinding(keys: ".", description: "Repeat last change", mode: "n", category: "editing"),
        Keybinding(keys: "x", description: "Delete character", mode: "n", category: "editing"),
        Keybinding(keys: "ciw", description: "Change inner word", mode: "n", category: "editing"),
        Keybinding(keys: "diw", description: "Delete inner word", mode: "n", category: "editing"),
        Keybinding(keys: "yiw", description: "Yank inner word", mode: "n", category: "editing"),
        Keybinding(keys: "ci\"", description: "Change inside quotes", mode: "n", category: "editing"),
        Keybinding(keys: "di\"", description: "Delete inside quotes", mode: "n", category: "editing"),
        Keybinding(keys: "J", description: "Join lines", mode: "n", category: "editing"),
        Keybinding(keys: "<A-j>", description: "Move line down", mode: "n", category: "editing"),
        Keybinding(keys: "<A-k>", description: "Move line up", mode: "n", category: "editing"),
        Keybinding(keys: "<A-j>", description: "Move selection down", mode: "v", category: "editing"),
        Keybinding(keys: "<A-k>", description: "Move selection up", mode: "v", category: "editing"),
        Keybinding(keys: ">", description: "Indent", mode: "v", category: "editing"),
        Keybinding(keys: "<", description: "Outdent", mode: "v", category: "editing"),
        Keybinding(keys: "gcc", description: "Toggle comment line", mode: "n", category: "editing"),
        Keybinding(keys: "gc", description: "Toggle comment selection", mode: "v", category: "editing"),

        // MARK: - Treesitter
        Keybinding(keys: "<C-space>", description: "Increment selection", mode: "n", category: "treesitter"),
        Keybinding(keys: "<BS>", description: "Decrement selection", mode: "x", category: "treesitter"),

        // MARK: - Notifications
        Keybinding(keys: "<leader>un", description: "Dismiss all notifications", mode: "n", category: "notifications"),
        Keybinding(keys: "<leader>sna", description: "Noice all", mode: "n", category: "notifications"),
        Keybinding(keys: "<leader>snd", description: "Dismiss all", mode: "n", category: "notifications"),
        Keybinding(keys: "<leader>snh", description: "Noice history", mode: "n", category: "notifications"),
        Keybinding(keys: "<leader>snl", description: "Noice last message", mode: "n", category: "notifications"),

        // MARK: - Trouble
        Keybinding(keys: "<leader>xx", description: "Diagnostics (Trouble)", mode: "n", category: "trouble"),
        Keybinding(keys: "<leader>xX", description: "Buffer diagnostics (Trouble)", mode: "n", category: "trouble"),
        Keybinding(keys: "<leader>cs", description: "Symbols (Trouble)", mode: "n", category: "trouble"),
        Keybinding(keys: "<leader>cS", description: "LSP references/definitions/... (Trouble)", mode: "n", category: "trouble"),
        Keybinding(keys: "<leader>xL", description: "Location list (Trouble)", mode: "n", category: "trouble"),
        Keybinding(keys: "<leader>xQ", description: "Quickfix list (Trouble)", mode: "n", category: "trouble"),
        Keybinding(keys: "[q", description: "Previous Trouble/Quickfix item", mode: "n", category: "trouble"),
        Keybinding(keys: "]q", description: "Next Trouble/Quickfix item", mode: "n", category: "trouble"),

        // MARK: - Todo Comments
        Keybinding(keys: "]t", description: "Next todo comment", mode: "n", category: "todo"),
        Keybinding(keys: "[t", description: "Previous todo comment", mode: "n", category: "todo"),
        Keybinding(keys: "<leader>st", description: "Todo", mode: "n", category: "todo"),
        Keybinding(keys: "<leader>sT", description: "Todo/Fix/Fixme", mode: "n", category: "todo"),
        Keybinding(keys: "<leader>xt", description: "Todo (Trouble)", mode: "n", category: "todo"),
        Keybinding(keys: "<leader>xT", description: "Todo/Fix/Fixme (Trouble)", mode: "n", category: "todo"),
    ]

    static func byCategory() -> [String: [Keybinding]] {
        Dictionary(grouping: defaults, by: \.category)
    }
}
