# Qoppa

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A minimal, local AI terminal assistant for `zsh` users.

<https://github.com/user-attachments/assets/d3b20796-66ff-42e5-b642-7ab6a720b968>

## Usage

```bash
# Translate natural language into a shell command
q find large files modified in the last week

# Follow up on the previous query
q! last two weeks

# Generate another command inline using documentation as context
man less | q less auto exit if output fits on screen

# Ask an open-ended question and read a longer explanation
qq what does qoppa mean

# Ask a follow-up question grounded in source material
curl 'https://en.wikipedia.org/wiki/Koppa?action=raw' | qq! when was the lowercase form added to unicode
```

## Requirements

- [LM Studio](https://lmstudio.ai/) installed and [`lms`](https://lmstudio.ai/docs/cli) in your PATH
- Your favorite local model loaded and ready to go

## Installation

### macOS/Linux

```bash
curl -fsSL https://raw.githubusercontent.com/moltinginstar/qoppa/main/install.sh | sh
```

Then, add this line to your [`~/.zshrc`](~/.zshrc):

```bash
source ~/.local/share/qoppa/qoppa.zsh
```

### Nix (Home Manager)

First, run:

```bash
nix run nixpkgs#nix-prefetch-github -- moltinginstar qoppa
```

Next, add the repository as a `zsh` plugin in your Home Manager configuration using the obtained revision and hash:

```nix
{
  programs.zsh = {
    plugins = [
      {
        name = "qoppa";
        src = pkgs.fetchFromGitHub {
          owner = "moltinginstar";
          repo = "qoppa";
          rev = "<rev>";
          sha256 = "<hash>";
        };
        file = "qoppa.zsh";
      }
    ];
  };
}
```

## Configuration

Qoppa supports the following options (must be set in [`~/.zshrc`](~/.zshrc) _before_ sourcing `qoppa.zsh`):

```bash
# The command qq uses to display responses (default: mcat -> bat -> less)
QOPPA_VIEWER=(glow -p -w 40)

# Lets the AI know what tools to use (default: fd, fzf, ripgrep, jq, git-filter-repo, uv)
QOPPA_PREFERRED_TOOLS="nix, fd, fzf, ripgrep, nu, git-filter-repo, uv, nvim"

# Additional context injected into the system prompt (default: none)
function _qoppa_extra_context() {
  git rev-parse --is-inside-work-tree > /dev/null 2>&1 \
    && echo "Git branch: $(git branch --show-current)"
}
```

## License

This project is licensed under the [MIT License](LICENSE).
