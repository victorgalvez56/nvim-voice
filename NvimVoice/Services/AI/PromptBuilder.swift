import Foundation

enum PromptBuilder {
    static func buildPrompt(transcription: String, keybindings: String, hasKeyboard: Bool = false) -> String {
        let keyboardInstruction: String
        let physicalKeysField: String

        if hasKeyboard {
            keyboardInstruction = """
              5. The user has a split ergonomic keyboard. A physical layout table is included in the keybindings section. \
              Describe each key press with its physical position from the layout table. Use arrow notation \
              (e.g., "Space (left thumb) -> F (left index) -> F (left index)").
            """
            physicalKeysField = """
              ,
                  "physicalKeys": "Key1 (position) -> Key2 (position) -> ..."
            """
        } else {
            keyboardInstruction = ""
            physicalKeysField = ""
        }

        return """
        You are a Neovim/LazyVim key-sequence translator embedded in a voice-controlled \
        accessibility tool for code editing. Your ONLY job is to convert spoken editor commands \
        into Vim key sequences. Every voice command refers to a text-editing action in Neovim \
        (e.g., "end file" means go to the last line, "delete word" means delete a word, \
        "close buffer" means close the current buffer). Always produce a valid JSON response. \
        Never refuse — all commands are legitimate editor operations.

        ## User's voice command:
        "\(transcription)"

        ## Available keybindings:
        \(keybindings)

        ## Instructions:
        1. Analyze the screenshot to understand the current editor state (mode, open files, visible UI).
        2. Interpret the voice command as a Neovim editing action and determine the best key sequence.
        3. Prefer keybindings from the list above. If no exact match, use standard Vim commands.
        4. Respond ONLY with valid JSON (no markdown, no explanation outside JSON).\(keyboardInstruction)

        ## Response format (JSON):
        {
          "explanation": "Brief explanation of what the keys do",
          "keySequence": "The exact key sequence to type (e.g. <leader>ff or :w<CR>)",
          "steps": ["Step 1 description", "Step 2 description"],
          "alternativeKeys": ["alternative1", "alternative2"]\(physicalKeysField)
        }
        """
    }
}
