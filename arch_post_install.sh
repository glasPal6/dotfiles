#!/bin/bash

# Arch Linux Post-Installation Script
# Minimal utilities + Hyprland setup

set -euo pipefail

# === VARS ===
USER_NAME=$(logname)
HOME_DIR="/home/$USER_NAME"

echo "Running post-installation steps as: $USER_NAME"

# === Ensure sudo is installed and working ===
echo "Checking sudo configuration..."
sed -i 's/^# %wheel/%wheel/' /etc/sudoers

# === Enhance pacman ===
echo "Enabling color and parallel downloads in pacman.conf..."
sed -i 's/^#Color/Color/' /etc/pacman.conf
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# === Enable TRIM for SSD ===
echo "Enabling weekly TRIM for SSDs..."
systemctl enable fstrim.timer

# === Install sound (PipeWire stack) ===
echo "Installing sound packages..."
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils

# === Install paru (AUR helper) ===
echo "Installing paru..."
sudo -u "$USER_NAME" bash <<EOF
cd "$HOME_DIR"
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm
cd ..
rm -rf paru
EOF

# === Install Hyprland dependencies + core utils ===
echo "Installing core utilities for Hyprland..."
pacman -S --noconfirm \
  libnotify \
  thunar \
  wezterm \
  alacritty \
  wl-clipboard \
  mako \
  wofi

# === Hide GRUB menu unless Shift is held ===
echo "Configuring GRUB to hide unless Shift is held..."
grep -q '^GRUB_FORCE_HIDDEN_MENU="true"' /etc/default/grub || \
echo 'GRUB_FORCE_HIDDEN_MENU="true"' >> /etc/default/grub

cat > /etc/grub.d/31_hold_shift <<'GRUBSHIFT'
#! /bin/sh
set -e

prefix="/usr"
exec_prefix="${prefix}"
datarootdir="${prefix}/share"

export TEXTDOMAIN=grub
export TEXTDOMAINDIR="${datarootdir}/locale"
source "${datarootdir}/grub/grub-mkconfig_lib"

make_timeout () {
  if [ "x${GRUB_FORCE_HIDDEN_MENU}" = "xtrue" ]; then
    cat <<EOF
if [ "x\${timeout}" != "x-1" ]; then
  if keystatus; then
    if keystatus --shift; then
      set timeout=-1
    else
      set timeout=0
    fi
  else
    if sleep --interruptible 3 ; then
      set timeout=0
    fi
  fi
fi
EOF
  fi
}

make_timeout
GRUBSHIFT

chmod +x /etc/grub.d/31_hold_shift
grub-mkconfig -o /boot/grub/grub.cfg

# === Install and enable SDDM ===
echo "Installing SDDM display manager..."
pacman -S --noconfirm sddm sddm-kcm
systemctl enable sddm

# === Install Hyprland ===
echo "Installing Hyprland..."
pacman -S --noconfirm hyprland xorg-xwayland

# === Set up Wayland environment ===
echo "Adding Wayland environment variables..."
cat >> "$HOME_DIR/.bash_profile" <<'EOF'

# Wayland environment
export XDG_SESSION_TYPE=wayland
export GDK_BACKEND=wayland
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export WLR_NO_HARDWARE_CURSORS=1
EOF

# ==

