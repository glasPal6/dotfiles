#!/usr/bin/env bash
set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERR]${NC}   $*"; }

# ── Config ──────────────────────────────────────────────────────────
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Directories to stow (macOS-relevant configs)
STOW_DIRS=(
    ghostty
    zellij
    starship
    zsh
    nvim
    pypoetry
    pi
    tmux
    scripts
    bash
)

# Homebrew formulae
BREW_FORMULAE=(
    # Core tools (idempotent — skips if already installed)
    neovim
    zellij
    starship
    fzf
    eza
    fd
    ripgrep
    bat
    tmux
    stow
    node
    uv
    zoxide
    mise
    tree-sitter
    pipx
    git-lfs
)

# Homebrew casks
BREW_CASKS=(
    ghostty
    zen
    orbstack
    localsend
    raycast
    font-jetbrains-mono-nerd-font
)

# Brew formulae from third-party taps
BREW_TAP_FORMULAE=(
    bnjreece/loudcue/loudcue
    tobi/try/try
)

# ── Preflight ───────────────────────────────────────────────────────
if [[ ! -d "$DOTFILES_DIR/.git" ]]; then
    err "Not inside a git repo. Run from dotfiles root."
    exit 1
fi

# ── Homebrew ────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

info "Updating Homebrew..."
brew update

# ── Brew Taps ──────────────────────────────────────────────────────
info "Adding brew taps..."
brew tap bnjreece/loudcue 2>/dev/null || true
brew tap tobi/try https://github.com/tobi/try 2>/dev/null || true

# ── Brew Formulae ──────────────────────────────────────────────────
info "Installing brew formulae..."
for pkg in "${BREW_FORMULAE[@]}"; do
    if brew list "$pkg" &>/dev/null; then
        ok "$pkg already installed"
    else
        info "Installing $pkg..."
        brew install "$pkg"
        ok "$pkg installed"
    fi
done

# ── Brew Tap Formulae ─────────────────────────────────────────────
info "Installing tap formulae..."
for pkg in "${BREW_TAP_FORMULAE[@]}"; do
    name="${pkg##*/}"
    if brew list "$name" &>/dev/null; then
        ok "$name already installed"
    else
        info "Installing $pkg..."
        brew install "$pkg"
        ok "$name installed"
    fi
done

# ── Brew Casks ─────────────────────────────────────────────────────
info "Installing brew casks..."
for cask in "${BREW_CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
        ok "$cask already installed"
    else
        info "Installing $cask..."
        brew install --cask "$cask"
        ok "$cask installed"
    fi
done

# ── Bun ─────────────────────────────────────────────────────────────
if ! command -v bun &>/dev/null; then
    info "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    ok "bun installed"
else
    ok "bun already installed"
fi

# ── Pi (coding agent) ──────────────────────────────────────────────
if ! command -v pi &>/dev/null; then
    info "Installing pi..."
    npm install -g pi-coding-agent
    ok "pi installed"
else
    ok "pi already installed"
fi


# ── Pi extensions ──────────────────────────────────────────────────
PI_EXTENSIONS=(
    npm:pi-subagents
    npm:pi-web-access
    npm:pi-powerline-footer
    npm:pi-ask-user
    npm:pi-hashline-readmap
    npm:pi-rewind
    npm:pi-caveman
    npm:pi-memory
    npm:@tmustier/pi-usage-extension
    npm:context-mode
    npm:pi-mcp-adapter
    npm:spotme
    npm:pi-intercom
    npm:pi-prompt-template-model
)

if command -v pi &>/dev/null; then
    info "Installing pi extensions..."
    for ext in "${PI_EXTENSIONS[@]}"; do
        name="${ext##*/}"
        if pi list 2>/dev/null | grep -q "$name"; then
            ok "pi/$name already installed"
        else
            info "Installing $ext..."
            pi install "$ext" 2>/dev/null && ok "pi/$name installed" || warn "pi/$name failed"
        fi
    done
fi

# ── Stow ────────────────────────────────────────────────────────────
info "Creating symlinks with stow..."
cd "$DOTFILES_DIR"
for dir in "${STOW_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        info "Stowing $dir..."
        stow -v -d "$DOTFILES_DIR" -t "$HOME" --restow "$dir" 2>&1 | while read -r line; do
            echo "  $line"
        done
        ok "Stowed $dir"
    else
        warn "Directory $dir not found, skipping"
    fi
done

# ── Tmux Plugin Manager ────────────────────────────────────────────
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    info "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
else
    ok "TPM already installed"
fi

# Install tmux plugins via TPM
if [[ -x "$TPM_DIR/bin/install_plugins" ]]; then
    info "Installing tmux plugins..."
    "$TPM_DIR/bin/install_plugins"
    ok "tmux plugins installed"
fi

# ── FZF keybindings ────────────────────────────────────────────────
if [[ ! -f ~/.fzf.zsh ]]; then
    info "Setting up fzf keybindings..."
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc
    ok "fzf integration installed"
else
    ok "fzf integration already set up"
fi

# ── Zinit (for zsh plugins) ────────────────────────────────────────
ZINIT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_DIR" ]]; then
    info "Zinit will be auto-installed on first zsh launch"
else
    ok "Zinit already installed"
fi

# ── Git config ──────────────────────────────────────────────────────
info "Linking gitconfig..."
if [[ ! -L ~/.gitconfig ]] && [[ ! -f ~/.gitconfig ]]; then
    ln -s "$DOTFILES_DIR/scripts/.gitconfig" ~/.gitconfig
    ok "gitconfig linked"
elif [[ -L ~/.gitconfig ]]; then
    ok "gitconfig already linked"
else
    warn "gitconfig exists and is not a symlink — skipping (back up and re-run if needed)"
fi


# ── try directory ──────────────────────────────────────────────────
TRIES_DIR="$HOME/Documents/Experiments"
if [[ ! -d "$TRIES_DIR" ]]; then
    info "Creating tries directory..."
    mkdir -p "$TRIES_DIR"
    ok "Created $TRIES_DIR"
else
    ok "tries directory exists"
fi
# ── Summary ─────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN} Setup complete!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  Installed:"
echo "    brew formulae:     ${#BREW_FORMULAE[@]}"
echo "    brew tap formulae: ${#BREW_TAP_FORMULAE[@]}"
echo "    brew casks:        ${#BREW_CASKS[@]}"
echo "    bun:               $(command -v bun 2>/dev/null || echo 'not found')"
echo "    pi:                $(command -v pi 2>/dev/null || echo 'not found')"
echo "    stow dirs:         ${#STOW_DIRS[@]}"
echo ""
echo "  Not in Homebrew (install manually if needed):"
echo "    - screenzen: https://screenzen.app"
echo "    - autoraise: check GitHub / direct download"
echo ""
echo "  Next steps:"
echo "    1. Open a new terminal (or run: source ~/.zshrc)"
echo "    2. Open nvim — lazy.nvim will auto-install plugins"
    3. Open nvim — Mason auto-installs LSPs on first launch
echo "    4. Launch pi: pi"
echo ""
echo "  Fonts: JetBrains Mono Nerd Font installed."
echo "         Select it in Ghostty config if not auto-detected."
echo ""
