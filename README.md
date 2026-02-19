**NvimVoice** — Control Neovim with your voice.

NvimVoice is a macOS menu bar app that translates voice commands into Neovim/LazyVim keybindings. Speak what you want to do, and the app shows you the exact keys to press, with visual context from your editor.

### Features

- **Voice to keybindings** — Press Cmd+Shift+V, speak a command and get the exact Neovim/LazyVim keybinding.
- **Local transcription** — Whisper runs locally via WhisperKit. No audio sent to the cloud.
- **Visual analysis** — Captures your screen and uses GPT-4 Vision to understand your editor context.
- **Floating overlay** — Displays results in a floating window with key sequence, explanation, steps and alternatives.
- **Custom keybindings** — Parses your Neovim config (~/.config/nvim/lua) and merges it with LazyVim defaults.
- **Native menu bar** — Status indicators, permissions, recording and results from the menu bar.
- **Esc to cancel** — Cancel recording or processing at any time.
- **Secure storage** — API key encrypted with AES-GCM using hardware UUID.
- **Debug logging** — Structured logs at ~/.config/nvimvoice/debug.log.

### Tech Stack

- **Language**: Swift 5.9+
- **Platform**: macOS 14.0+
- **UI**: SwiftUI (MenuBarExtra + NSPanel overlay)
- **Transcription**: WhisperKit 0.9+ (local Whisper)
- **AI**: OpenAI GPT-4 Vision (gpt-4o)
- **Audio**: AVAudioEngine (16kHz mono Float32)
- **Capture**: ScreenCaptureKit
- **Security**: CryptoKit (AES-GCM)
- **Build**: Swift Package Manager + Makefile

### Required Permissions

- **Microphone** — To record voice commands.
- **Screen Recording** — To capture visual context from the editor.
- **Accessibility** — For the global hotkey (Cmd+Shift+V).

### Installation

```bash
# Clone the repo
git clone https://github.com/victorgalvez56/nvim-voice.git
cd nvim-voice

# Build and install to /Applications
make install

# Or just run in dev mode
make dev
```

### Makefile

| Command | Description |
|---------|-------------|
| `make dev` | Debug build + codesign + relaunch (~2-3s) |
| `make watch` | Auto-rebuild on .swift changes |
| `make build` | Release build |
| `make bundle` | Create app bundle |
| `make run` | Bundle + launch |
| `make install` | Copy to /Applications |
| `make clean` | Clean build artifacts |

### Configuration

Configure the app from the menu bar → Settings:

- **General**: Whisper model (tiny/base/small), overlay duration, image detail level.
- **API**: OpenAI API key (stored encrypted at ~/.config/nvimvoice/.api-key).

### How It Works

1. Press **Cmd+Shift+V** (global hotkey).
2. Speak your command (e.g. "find files in this project").
3. Press **Cmd+Shift+V** again to stop.
4. Whisper transcribes the audio locally.
5. A screenshot of your editor is captured.
6. GPT-4 Vision analyzes transcription + screenshot + available keybindings.
7. The overlay shows the key sequence (e.g. `<leader>ff`), explanation and alternatives.
