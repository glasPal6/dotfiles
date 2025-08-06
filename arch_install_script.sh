#!/bin/bash

# Arch Linux BTRFS Installation Script with Hyprland and ZSH
# Based on the guide with BTRFS subvolumes and snapshots

# Installation logging
exec &> >(tee "arch_install_log_$(date +%Y%m%d_%H%M%S).txt")

set -e  # Exit on error

# Text formatting
bold=$(tput bold)
normal=$(tput sgr0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

# Function to print section headers
print_section() {
    echo -e "\n${bold}${blue}==>${normal}${bold} $1${normal}\n"
}

# Function to print error messages and exit
error() {
    echo -e "${bold}${red}ERROR:${normal} $1" >&2
    exit 1
}

# Cleanup function for interrupted installation
cleanup() {
    echo "Installation interrupted. Cleaning up..."
    umount -R /mnt 2>/dev/null || true
    exit 1
}
trap cleanup INT TERM

# Function to ask for confirmation
confirm() {
    read -p "${yellow}$1 [y/N]${normal} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

print_section "Arch Linux Installation with BTRFS and Hyprland"
echo "This script will install Arch Linux with BTRFS subvolumes, snapshot support, Hyprland, and ZSH."
echo "WARNING: This will ERASE ALL DATA on the selected disk!"

# Check for internet connectivity
print_section "Checking Internet Connectivity"
ping -c 1 archlinux.org > /dev/null 2>&1 || error "No internet connection available. Please connect before proceeding."
echo "Internet connectivity confirmed."

if ! confirm "Do you want to continue?"; then
    error "Installation aborted by user"
fi

# Select installation disk
print_section "Disk Selection"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
echo ""
read -p "Enter the disk to install to (e.g., sda, nvme0n1): " disk

if [[ ! -b /dev/${disk} ]]; then
    error "Disk /dev/${disk} not found!"
fi

if confirm "Is this an NVMe device?"; then
    is_nvme=true
    # For NVMe drives, partitions are named differently (nvme0n1p1 instead of nvme0n11)
    part1="${disk}p1"
    part2="${disk}p2"
    part3="${disk}p3"
else
    is_nvme=false
    # For normal drives (sda1, sdb1, etc.)
    part1="${disk}1"
    part2="${disk}2"
    part3="${disk}3"
fi

# Ask about swap type
use_swap_file=false
if confirm "Would you like to create a swap file instead of a swap partition?"; then
    use_swap_file=true
    read -p "Enter swap file size in GB (default: 2): " swap_size
    swap_size=${swap_size:-2}
else
    read -p "Enter swap partition size in GB (default: 2): " swap_size
    swap_size=${swap_size:-2}
fi

# Get CPU type for microcode
if grep -q "GenuineIntel" /proc/cpuinfo; then
    microcode="intel-ucode"
else
    microcode="amd-ucode"
fi

# Get hostname
read -p "Enter hostname: " hostname

# Get username
read -p "Enter username: " username

# Get user password
read -s -p "Enter password for $username: " user_password
echo ""
read -s -p "Confirm password: " user_password_confirm
echo ""

if [[ "$user_password" != "$user_password_confirm" ]]; then
    error "Passwords do not match!"
fi

# Get root password
read -s -p "Enter root password: " root_password
echo ""
read -s -p "Confirm root password: " root_password_confirm
echo ""

if [[ "$root_password" != "$root_password_confirm" ]]; then
    error "Root passwords do not match!"
fi

# Select timezone
print_section "Timezone Selection"
echo "Common timezones:"
echo "1) Africa/Johannesburg"
echo "2) America/New_York"
echo "3) America/Chicago"
echo "4) America/Los_Angeles"
echo "5) Europe/London"
echo "6) Europe/Berlin"
echo "7) Asia/Tokyo"
echo "8) Australia/Sydney"
echo "9) Pacific/Auckland"
echo "0) Other (manually enter)"

read -p "Select your timezone [0-9]: " tz_choice

case $tz_choice in
    1) timezone="Africa/Johannesburg" ;;
    2) timezone="America/New_York" ;;
    3) timezone="America/Chicago" ;;
    4) timezone="America/Los_Angeles" ;;
    5) timezone="Europe/London" ;;
    6) timezone="Europe/Berlin" ;;
    7) timezone="Asia/Tokyo" ;;
    8) timezone="Australia/Sydney" ;;
    9) timezone="Pacific/Auckland" ;;
    0) 
        echo "Available timezones (press q to exit the list):"
        timedatectl list-timezones | less
        read -p "Enter your timezone: " timezone
        ;;
    *) timezone="UTC" ;;
esac

# Select keyboard layout
print_section "Keyboard Layout"
echo "Common keyboard layouts:"
echo "1) us (Default)"
echo "2) uk"
echo "3) de"
echo "4) fr"
echo "5) es"
echo "0) Other"

read -p "Select your keyboard layout [0-5]: " kb_choice

case $kb_choice in
    1|"") keymap="us" ;;
    2) keymap="uk" ;;
    3) keymap="de" ;;
    4) keymap="fr" ;;
    5) keymap="es" ;;
    0) 
        localectl list-keymaps | less
        read -p "Enter your keyboard layout: " keymap
        ;;
    *) keymap="us" ;;
esac

loadkeys $keymap

# Update mirrors
print_section "Optimizing Pacman Mirrors"
if confirm "Would you like to update mirrors to find the fastest servers?"; then
    pacman -Sy --noconfirm reflector
    reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    echo "Mirrors optimized."
fi

# Partitioning
print_section "Partitioning the Disk"
if confirm "This will erase ALL data on /dev/${disk}. Are you ABSOLUTELY sure?"; then
    echo "Partitioning disk..."
    
    if [ "$use_swap_file" = true ]; then
        # Create partition table with boot and root only
        sgdisk -Z /dev/${disk}
        sgdisk -n 1:0:+512M -t 1:ef00 /dev/${disk}  # EFI partition
        sgdisk -n 2:0:0 -t 2:8300 /dev/${disk}      # Root partition
        
        # Format partitions
        echo "Formatting partitions..."
        mkfs.fat -F32 /dev/${part1}
        mkfs.btrfs -L archLinux /dev/${part2}
    else
        # Create partition table with boot, swap, and root
        sgdisk -Z /dev/${disk}
        sgdisk -n 1:0:+512M -t 1:ef00 /dev/${disk}  # EFI partition
        sgdisk -n 2:0:+${swap_size}G -t 2:8200 /dev/${disk}  # Swap partition
        sgdisk -n 3:0:0 -t 3:8300 /dev/${disk}      # Root partition
        
        # Format partitions
        echo "Formatting partitions..."
        mkfs.fat -F32 /dev/${part1}
        mkswap /dev/${part2}
        mkfs.btrfs -L archLinux /dev/${part3}
        
        # Enable swap
        swapon /dev/${part2}
    fi
else
    error "Installation aborted by user"
fi

# BTRFS subvolumes setup
print_section "Creating BTRFS Subvolumes"
if [ "$use_swap_file" = true ]; then
    mount /dev/${part2} /mnt
    root_partition=${part2}
else
    mount /dev/${part3} /mnt
    root_partition=${part3}
fi

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@docker
umount /mnt

# Mount subvolumes
print_section "Mounting Subvolumes"
if [ "$is_nvme" = true ]; then
    # For NVMe, use zstd compression
    subvol_options="rw,noatime,compress-force=zstd:1,space_cache=v2"
else
    # For regular disks
    subvol_options="rw,noatime,compress=zstd:1,space_cache=v2"
fi

# Mount root subvolume
mount -o ${subvol_options},subvol=@ /dev/${root_partition} /mnt

# Create mount points
mkdir -p /mnt/{boot,home,.snapshots,var/cache,var/log,var/tmp,var/lib/docker}

# Mount the subvolumes
mount -o ${subvol_options},subvol=@home /dev/${root_partition} /mnt/home
mount -o ${subvol_options},subvol=@snapshots /dev/${root_partition} /mnt/.snapshots
mount -o ${subvol_options},subvol=@cache /dev/${root_partition} /mnt/var/cache
mount -o ${subvol_options},subvol=@log /dev/${root_partition} /mnt/var/log
mount -o ${subvol_options},subvol=@tmp /dev/${root_partition} /mnt/var/tmp
mount -o ${subvol_options},subvol=@docker /dev/${root_partition} /mnt/var/lib/docker
mount /dev/${part1} /mnt/boot

# Create swap file if selected
if [ "$use_swap_file" = true ]; then
    print_section "Creating Swap File"
    btrfs filesystem mkswapfile --size ${swap_size}g --uuid clear /mnt/swapfile
    swapon /mnt/swapfile
    echo "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab
fi

# Install base system
print_section "Installing Base System"
pacman -Syy --noconfirm archlinux-keyring
pacstrap /mnt base base-devel linux linux-firmware ${microcode} btrfs-progs neovim networkmanager git htop man-db fwupd zsh zsh-completions

# Generate fstab
print_section "Generating fstab"
genfstab -U -p /mnt > /mnt/etc/fstab

# Chroot configuration script
print_section "Setting up chroot environment"
cat > /mnt/setup.sh <<EOF
#!/bin/bash
set -e

# Time zone
echo "Setting timezone to ${timezone}..."
ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
hwclock --systohc

# Locale
echo "Configuring locale..."
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

# Keyboard layout
echo "KEYMAP=${keymap}" > /etc/vconsole.conf

# Network configuration
echo "Configuring network..."
echo "${hostname}" > /etc/hostname
cat > /etc/hosts <<HOSTS
127.0.0.1 localhost
::1       localhost
127.0.1.1 ${hostname}.localdomain ${hostname}
HOSTS

# Enable time synchronization
systemctl enable systemd-timesyncd.service

# Set default editor
echo "Setting default editor..."
echo "EDITOR=nvim" > /etc/environment
echo "VISUAL=nvim" >> /etc/environment

# Root password
echo "Setting root password..."
echo "root:${root_password}" | chpasswd

# Add user with ZSH as default shell
echo "Creating user account with ZSH shell..."
useradd -m -G wheel -s /usr/bin/zsh ${username}
echo "${username}:${user_password}" | chpasswd
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Enable network manager
systemctl enable NetworkManager.service

# Detect graphics card and install drivers
echo "Installing graphics drivers..."
if lspci | grep -i "nvidia" > /dev/null; then
    pacman -S --noconfirm nvidia nvidia-utils
fi
if lspci | grep -i "amd" | grep -i "vga\|3d" > /dev/null; then
    pacman -S --noconfirm xf86-video-amdgpu
fi
if lspci | grep -i "intel" | grep -i "vga\|3d" > /dev/null; then
    pacman -S --noconfirm xf86-video-intel
fi

# Configure pacman
echo "Configuring pacman..."
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

# Install common packages
echo "Installing common packages..."
pacman -S --noconfirm reflector libnotify

# Install and configure bootloader
echo "Installing bootloader..."
pacman -S --noconfirm grub efibootmgr grub-btrfs inotify-tools

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --boot-directory=/boot --bootloader-id=GRUB

# Configure grub-btrfs
sed -i 's/#GRUB_BTRFS_GRUB_DIRNAME="\/boot\/grub"/GRUB_BTRFS_GRUB_DIRNAME="\/boot\/grub"/' /etc/default/grub-btrfs/config
systemctl enable grub-btrfsd.service

# Add btrfs to mkinitcpio
sed -i 's/MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck grub-btrfs-overlayfs)/' /etc/mkinitcpio.conf
mkinitcpio -P

# Generate GRUB config
grub-mkconfig -o /boot/grub/grub.cfg

# Configure GRUB timeout (hidden menu)
grep -q '^GRUB_FORCE_HIDDEN_MENU="true"' /etc/default/grub || echo 'GRUB_FORCE_HIDDEN_MENU="true"' >> /etc/default/grub

cat > /etc/grub.d/31_hold_shift <<'GRUBSHIFT'
#! /bin/sh
set -e

prefix="/usr"
exec_prefix="\${prefix}"
datarootdir="\${prefix}/share"

export TEXTDOMAIN=grub
export TEXTDOMAINDIR="\${datarootdir}/locale"
source "\${datarootdir}/grub/grub-mkconfig_lib"

found_other_os=

make_timeout () {
  if [ "x\${GRUB_FORCE_HIDDEN_MENU}" = "xtrue" ] ; then
    if [ "x\${1}" != "x" ] ; then
      if [ "x\${GRUB_HIDDEN_TIMEOUT_QUIET}" = "xtrue" ] ; then
        verbose=
      else
        verbose=" --verbose"
      fi

      if [ "x\${1}" = "x0" ] ; then
        cat <<EOF
if [ "x\\\${timeout}" != "x-1" ]; then
  if keystatus; then
    if keystatus --shift; then
      set timeout=-1
    else
      set timeout=0
    fi
  else
    if sleep\$verbose --interruptible 3 ; then
      set timeout=0
    fi
  fi
fi
EOF
      else
        cat << EOF
if [ "x\\\${timeout}" != "x-1" ]; then
  if sleep\$verbose --interruptible \${GRUB_HIDDEN_TIMEOUT} ; then
    set timeout=0
  fi
fi
EOF
      fi
    fi
  fi
}

adjust_timeout () {
  if [ "x\$GRUB_BUTTON_CMOS_ADDRESS" != "x" ]; then
    cat <<EOF
if cmostest \$GRUB_BUTTON_CMOS_ADDRESS ; then
EOF
    make_timeout "\${GRUB_HIDDEN_TIMEOUT_BUTTON}" "\${GRUB_TIMEOUT_BUTTON}"
    echo else
    make_timeout "\${GRUB_HIDDEN_TIMEOUT}" "\${GRUB_TIMEOUT}"
    echo fi
  else
    make_timeout "\${GRUB_HIDDEN_TIMEOUT}" "\${GRUB_TIMEOUT}"
  fi
}

adjust_timeout

cat <<EOF
if [ "x\\\${timeout}" != "x-1" ]; then
  if keystatus; then
    if keystatus --shift; then
      set timeout=-1
    else
      set timeout=0
    fi
  else
    if sleep\$verbose --interruptible 3 ; then
      set timeout=0
    fi
  fi
fi
EOF
GRUBSHIFT

chmod +x /etc/grub.d/31_hold_shift
grub-mkconfig -o /boot/grub/grub.cfg

# Install sound
echo "Setting up sound..."
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils

# Enable TRIM for SSDs
echo "Enabling SSD TRIM..."
systemctl enable fstrim.timer

# Install and configure firewall
echo "Setting up firewall..."
pacman -S --noconfirm ufw
systemctl enable ufw
ufw default deny
ufw allow ssh
ufw enable

# Install Bluetooth support
echo "Installing Bluetooth support..."
pacman -S --noconfirm bluez bluez-utils
systemctl enable bluetooth.service

# Install and configure Docker
echo "Setting up Docker..."
pacman -S --noconfirm docker docker-compose
systemctl enable docker.service
usermod -aG docker ${username}

# Install Hyprland and dependencies
echo "Installing Hyprland..."
pacman -S --noconfirm sddm hyprland wayland xorg-xwayland wl-clipboard grim slurp mako wofi swaybg swaylock swayidle alacritty thunar
systemctl enable sddm

# Install Oh-My-Zsh
echo "Installing Oh-My-Zsh..."
pacman -S --noconfirm curl
sudo -u ${username} sh -c "\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Create Wayland environment setup
cat > /home/${username}/.zprofile <<'WLENV'
# Wayland specific environment variables
if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then
  export XDG_SESSION_TYPE=wayland
  export GDK_BACKEND=wayland
  export QT_QPA_PLATFORM=wayland
  export CLUTTER_BACKEND=wayland
  export SDL_VIDEODRIVER=wayland
  export _JAVA_AWT_WM_NONREPARENTING=1
  export WLR_NO_HARDWARE_CURSORS=1
fi
WLENV
chown ${username}:${username} /home/${username}/.zprofile

# Setup basic Hyprland config
mkdir -p /home/${username}/.config/hypr
cp /etc/hypr/hyprland.conf /home/${username}/.config/hypr/hyprland.conf
chown -R ${username}:${username} /home/${username}/.config

# Install ZSH plugins
echo "Installing ZSH plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/${username}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git /home/${username}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
chown -R ${username}:${username} /home/${username}/.oh-my-zsh

# Configure ZSH
sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' /home/${username}/.zshrc
chown ${username}:${username} /home/${username}/.zshrc

# Install snapper for snapshots
echo "Setting up Snapper..."
pacman -S --noconfirm snapper snap-pac

# Enable snapper timers
systemctl enable snapper-cleanup.timer
systemctl enable snapper-timeline.timer

# Exit the script
exit 0
EOF

chmod +x /mnt/setup.sh

# Run the chroot script
print_section "Executing configuration in chroot environment"
arch-chroot /mnt /setup.sh

# Setup Snapper post-install
print_section "Setting up Snapper"
arch-chroot /mnt bash -c "
umount /.snapshots || true
rmdir /.snapshots || true
snapper -c root create-config /
btrfs subvolume delete /.snapshots || true
mkdir /.snapshots
mount -a
chmod 750 /.snapshots
chown :wheel /.snapshots
snapper -c root create -d \"**Base system**\"
sed -i 's/ALLOW_USERS=\"\"/ALLOW_USERS=\"${username}\"/' /etc/snapper/configs/root
"

# Clean up
rm /mnt/setup.sh

print_section "Installation Complete!"
echo "${green}Arch Linux with Hyprland and ZSH has been successfully installed!${normal}"
echo "You can now reboot into your new Arch Linux system."
echo "After reboot, login as ${username} with your password."

if confirm "Do you want to reboot now?"; then
    umount -R /mnt
    reboot
else
    echo "When you're ready to boot into your new system, run:"
    echo "  umount -R /mnt"
    echo "  reboot"
fi
