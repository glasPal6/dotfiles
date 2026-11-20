#!/usr/bin/env bash
# Uninstall ghostty, tuios and zellij (macOS or Linux) and unstow their configs. The config stays in the dotfiles.
# Usage: remove-old-terminals [-n]   (-n only prints what would happen)
set -uo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
APPS=(ghostty tuios zellij)
dry=0; [[ ${1:-} == -n ]] && dry=1

run() { echo "+ $*"; (( dry )) || "$@"; }

if (( ! dry )); then
    read -rp "Remove ${APPS[*]} from this computer? [y/N] " answer
    [[ $answer == y ]] || exit 0
fi

# Stop running instances (tuios and zellij keep a server alive)
for app in tuios zellij ghostty; do
    pgrep -x "$app" >/dev/null && run pkill -x "$app"
done

# Unstow the configs (links only; the files stay in the dotfiles)
if command -v stow >/dev/null; then
    for app in "${APPS[@]}"; do
        [[ -d $DOTFILES_DIR/$app ]] && run stow -D -d "$DOTFILES_DIR" -t "$HOME" "$app"
    done
fi

# Uninstall with whichever package manager installed them
for app in "${APPS[@]}"; do
    if command -v brew >/dev/null; then
        brew list --cask "$app" &>/dev/null && run brew uninstall --cask "$app"
        brew list --formula "$app" &>/dev/null && run brew uninstall "$app"
    fi
    if command -v pacman >/dev/null && pacman -Q "$app" &>/dev/null; then run sudo pacman -Rns --noconfirm "$app"; fi
    if command -v apt-get >/dev/null && dpkg -s "$app" &>/dev/null; then run sudo apt-get remove -y "$app"; fi
    if command -v snap >/dev/null && snap list "$app" &>/dev/null; then run sudo snap remove "$app"; fi
    if command -v flatpak >/dev/null && flatpak list --app 2>/dev/null | grep -qi "$app"; then run flatpak uninstall -y "$app"; fi
    if command -v cargo >/dev/null && cargo install --list 2>/dev/null | grep -q "^$app "; then run cargo uninstall "$app"; fi
done

# Binaries dropped by hand (curl installs, GitHub releases)
for dir in "$HOME/.local/bin" "$HOME/bin" /usr/local/bin; do
    for app in "${APPS[@]}"; do
        [[ -e $dir/$app ]] || continue
        if [[ -w $dir ]]; then run rm -f "$dir/$app"; else run sudo rm -f "$dir/$app"; fi
    done
done

for app in "${APPS[@]}"; do
    command -v "$app" >/dev/null && echo "Still found: $(command -v "$app")"
done
echo "Done."
