#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="git@github.com:glasPal6/dotfiles.git"
REPO_NAME=".dotfiles"

is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL" .dotfiles
fi

# Check if the clone was successful
if [ $? -eq 0 ]; then
  echo "removing old configs"
  rm -rf \
    ~/.config/nvim \
    ~/.local/share/nvim/ \
    ~/.cache/nvim/ \
    ~/.config/ghostty/config \
    # ~/.config/starship.toml \

  cd "$REPO_NAME"
  # Install stow
  yay -S --noconfirm --needed stow
  
  stow ghostty
  stow nvim
  stow scripts
  stow starship
  stow waybar
else
  echo "Failed to clone the repository."
  exit 1
fi
