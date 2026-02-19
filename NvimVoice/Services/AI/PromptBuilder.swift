import Foundation

enum PromptBuilder {
    static func buildPrompt(transcription: String, keybindings: String) -> String {
        """
        You are an expert Neovim/LazyVim assistant. The user is looking at their Neovim editor \
        (shown in the screenshot) and gave a voice command describing what they want to do.

        ## User's voice command:
        "\(transcription)"

        ## Available keybindings:
        \(keybindings)

        ## Instructions:
        1. Analyze the screenshot to understand the current editor state (mode, open files, visible UI).
        2. Based on the voice command and the screenshot context, determine the best key sequence.
        3. Prefer keybindings from the list above. If no exact match, use standard Vim commands.
        4. Respond ONLY with valid JSON (no markdown, no explanation outside JSON).

        ## Response format (JSON):
        {
          "explanation": "Brief explanation of what the keys do",
          "keySequence": "The exact key sequence to type (e.g. <leader>ff or :w<CR>)",
          "steps": ["Step 1 description", "Step 2 description"],
          "alternativeKeys": ["alternative1", "alternative2"]
        }
        """
    }
}
