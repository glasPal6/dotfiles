#!/bin/bash

# Arch Linux Installation Script with BTRFS
# Based on: https://github.com/egara/arch-btrfs-installation and other sources

set -e

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored messages
print_message() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    print_error "This script must be run as root!"
    exit 1
fi

# Get user inputs
read -p "Enter the disk to install Arch Linux (e.g., sda, nvme0n1): " disk
read -p "Enter hostname: " hostname
read -p "Enter username: " username
read -s -p "Enter password for $username: " user_password
echo
read -s -p "Enter password for root: " root_password
echo

# Check if the disk exists
if [[ ! -b "/dev/$disk" ]]; then
    print_error "Disk /dev/$disk not found!"
    exit 1
fi

# Verify disk selection
print_warning "This will erase ALL data on /dev/$disk. Are you sure? (y/N): "
read confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    print_message "Installation aborted."
    exit 0
fi

# Detect CPU type for microcode
if grep -q "GenuineIntel" /proc/cpuinfo; then
    microcode="intel-ucode"
elif grep -q "AuthenticAMD" /proc/cpuinfo; then
    microcode="amd-ucode"
else
    print_warning "Could not determine CPU type. Defaulting to intel-ucode."
    microcode="intel-ucode"
fi

print_message "Starting Arch Linux installation with BTRFS on /dev/$disk"
print_message "CPU detected: $microcode will be installed"

# Create partitions using gdisk
print_message "Creating partitions on /dev/$disk"
# Create a new GPT partition table and the required partitions
sgdisk -Z /dev/$disk
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System Partition" /dev/$disk
sgdisk -n 2:0:+2G -t 2:8200 -c 2:"Swap" /dev/$disk
sgdisk -n 3:0:0 -t 3:8300 -c 3:"Arch Linux" /dev/$disk

# Wait for the kernel to update the partition table
sleep 2

# Format partitions
print_message "Formatting partitions"
# Determine the partition prefix (nvme drives use p1,p2,p3, others use 1,2,3)
if [[ "$disk" == nvme* ]]; then
    part_prefix="p"
else
    part_prefix=""
fi

# Format EFI partition
mkfs.fat -F32 /dev/$disk${part_prefix}1
# Create and activate swap
mkswap /dev/$disk${part_prefix}2
swapon /dev/$disk${part_prefix}2
# Format the main partition with BTRFS
mkfs.btrfs -L archLinux /dev/$disk${part_prefix}3

# Create BTRFS subvolumes
print_message "Creating BTRFS subvolumes"
mount /dev/$disk${part_prefix}3 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@docker

# Unmount and remount with subvolumes
print_message "Mounting subvolumes"
umount /mnt
subvol_options="rw,noatime,compress-force=zstd:1,space_cache=v2"

# Mount the root subvolume
mount -o ${subvol_options},subvol=@ /dev/$disk${part_prefix}3 /mnt

# Create mount points for other subvolumes
mkdir -p /mnt/{boot,home,.snapshots,var/cache,var/log,var/tmp,var/lib/docker}

# Mount all subvolumes
mount -o ${subvol_options},subvol=@home /dev/$disk${part_prefix}3 /mnt/home
mount -o ${subvol_options},subvol=@snapshots /dev/$disk${part_prefix}3 /mnt/.snapshots
mount -o ${subvol_options},subvol=@cache /dev/$disk${part_prefix}3 /mnt/var/cache
mount -o ${subvol_options},subvol=@log /dev/$disk${part_prefix}3 /mnt/var/log
mount -o ${subvol_options},subvol=@tmp /dev/$disk${part_prefix}3 /mnt/var/tmp
mount -o ${subvol_options},subvol=@docker /dev/$disk${part_prefix}3 /mnt/var/lib/docker
mount /dev/$disk${part_prefix}1 /mnt/boot

# Install base packages
print_message "Installing base system packages"
pacman -Syy --noconfirm
pacstrap /mnt base base-devel ${microcode} btrfs-progs linux linux-lts linux-firmware \
  bash-completion htop man-db neovim networkmanager tmux git

# Generate fstab
print_message "Generating fstab"
genfstab -U -p /mnt > /mnt/etc/fstab

# Chroot operations
print_message "Configuring the system"
arch-chroot /mnt /bin/bash << EOF

# System configuration
ln -sf /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime
hwclock --systohc

# Configure locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen

# Set hostname
echo "$hostname" > /etc/hostname
cat > /etc/hosts << HOSTS
127.0.0.1 localhost
::1 localhost
127.0.1.1 $hostname.localdomain $hostname
HOSTS

# Set default editor
echo "EDITOR=nvim" > /etc/environment
echo "VISUAL=nvim" >> /etc/environment

# Set passwords
echo "Setting root password"
echo "root:$root_password" | chpasswd
useradd -m -G wheel -s /bin/bash $username
echo "$username:$user_password" | chpasswd
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager

# Install GRUB
pacman -S --noconfirm grub efibootmgr grub-btrfs inotify-tools
grub-install --target=x86_64-efi --efi-directory=/boot --boot-directory=/boot --bootloader-id=GRUB
sed -i 's/#GRUB_BTRFS_GRUB_DIRNAME="\/boot\/grub"/GRUB_BTRFS_GRUB_DIRNAME="\/boot\/grub"/' /etc/default/grub-btrfs/config
systemctl enable grub-btrfsd.service

# Configure mkinitcpio
sed -i 's/MODULES=(/MODULES=(btrfs /' /etc/mkinitcpio.conf
if ! grep -q "grub-btrfs-overlayfs" /etc/mkinitcpio.conf; then
    sed -i 's/HOOKS=(\([^)]*\))/HOOKS=(\1 grub-btrfs-overlayfs)/' /etc/mkinitcpio.conf
fi
mkinitcpio -P

# Generate GRUB config
grub-mkconfig -o /boot/grub/grub.cfg

# Install snapper
pacman -S --noconfirm snapper snap-pac

EOF

print_message "Installation completed successfully!"
print_message "Please reboot the system and run the post-installation script to set up snapper and other utilities."

# Create post-installation script in the new system
cat > /mnt/home/$username/post-install.sh << 'EOF'
#!/bin/bash

# Arch Linux Post-Installation Script

set -e

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored messages
print_message() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

# Check if script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}Error:${NC} This script must be run as root!"
    exit 1
fi

print_message "Setting up snapper for system snapshots"

# Configure snapper
umount /.snapshots
rm -rf /.snapshots
snapper -c root create-config /
btrfs subvolume delete /.snapshots
mkdir /.snapshots
mount -a
chmod 750 /.snapshots
chown :wheel /.snapshots

# Take first snapshot
snapper -c root create -d "**Base system**"

# Get the current user
current_user=$(logname || echo $SUDO_USER)
print_message "Configuring snapper for user $current_user"

# Allow user to manage snapshots
sed -i "s/ALLOW_USERS=\"\"/ALLOW_USERS=\"$current_user\"/" /etc/snapper/configs/root
sed -i "s/SYNC_ACL=\"no\"/SYNC_ACL=\"yes\"/" /etc/snapper/configs/root

# Enable snapper timers
systemctl enable --now snapper-timeline.timer
systemctl enable --now snapper-cleanup.timer

# Enable TRIM for SSD
print_message "Enabling TRIM for SSD"
systemctl enable fstrim.timer

# Set up sound
print_message "Installing sound system"
pacman -S --noconfirm pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils

# Install PARU for AUR access
print_message "Installing PARU for AUR access"
if [ ! -d /tmp/paru-install ]; then
    mkdir -p /tmp/paru-install
    chown $current_user:$current_user /tmp/paru-install
fi

cd /tmp/paru-install
sudo -u $current_user git clone https://aur.archlinux.org/paru.git
cd paru
sudo -u $current_user makepkg -si --noconfirm
cd ..
rm -rf paru

# Enable color in pacman
print_message "Enabling color in pacman"
sed -i "s/#Color/Color/" /etc/pacman.conf

# Update the system
print_message "Updating system packages"
pacman -Syu --noconfirm

print_message "Post-installation completed successfully!"
print_message "You can now reboot and enjoy your Arch Linux system."
print_message "To test sound: pactl info | grep Pipe && speaker-test -c 2 -t wav -l 1"
print_message "To rollback system using snapshots, boot into the snapshot and run:"
print_message "sudo mount /dev/sdXY /mnt"
print_message "sudo mv /mnt/@ /mnt/@.broken  # or: sudo btrfs subvolume delete /mnt/@"
print_message "sudo btrfs subvolume snapshot /mnt/@snapshots/{number}/snapshot /mnt/@"
EOF

chmod +x /mnt/home/$username/post-install.sh
chown $username:$username /mnt/home/$username/post-install.sh

print_message "Run the post-installation script after reboot: sudo ./post-install.sh"
print_message "Unmounting and rebooting..."

umount -R /mnt

echo "Installation complete! Type 'reboot' to restart into your new Arch Linux system."
