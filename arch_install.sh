#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display header
clear
echo -e "${BLUE}=============================================${NC}"
echo -e "${GREEN}       Arch Linux BTRFS Install Script      ${NC}"
echo -e "${BLUE}=============================================${NC}"

# Function to display status messages
print_status() {
    echo -e "${YELLOW}[STATUS]${NC} $1"
}

# Function to display error messages
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to display success messages
print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to check if last command succeeded
check_success() {
    if [ $? -eq 0 ]; then
        print_success "$1"
    else
        print_error "$2"
        exit 1
    fi
}

# Get user input
get_disk() {
    lsblk
    echo -e "${YELLOW}Please enter the disk device to install Arch Linux (e.g. sda, nvme0n1):${NC}"
    read disk
    
    if [ ! -b "/dev/${disk}" ]; then
        print_error "Invalid disk. Please make sure the disk exists."
        get_disk
    fi
}

get_user_info() {
    echo -e "${YELLOW}Enter username:${NC}"
    read username
    
    echo -e "${YELLOW}Enter password for ${username}:${NC}"
    read -s user_password
    echo
    echo -e "${YELLOW}Confirm password for ${username}:${NC}"
    read -s user_password_confirm
    echo
    
    if [ "$user_password" != "$user_password_confirm" ]; then
        print_error "Passwords don't match. Please try again."
        get_user_info
    fi
    
    echo -e "${YELLOW}Enter root password:${NC}"
    read -s root_password
    echo
    echo -e "${YELLOW}Confirm root password:${NC}"
    read -s root_password_confirm
    echo
    
    if [ "$root_password" != "$root_password_confirm" ]; then
        print_error "Root passwords don't match. Please try again."
        get_user_info
    fi
    
    echo -e "${YELLOW}Enter hostname:${NC}"
    read hostname
}

# Main installation process
install_arch() {
    # Get necessary information
    get_disk
    get_user_info
    
    print_status "Beginning installation with disk /dev/${disk}"
    
    # Confirm before proceeding
    echo -e "${RED}WARNING: This will erase all data on /dev/${disk}${NC}"
    echo -e "${YELLOW}Do you want to proceed? (y/n)${NC}"
    read confirm
    if [ "$confirm" != "y" ]; then
        print_error "Installation cancelled."
        exit 1
    fi
    
    # Partition the disk
    print_status "Partitioning the disk..."
    
    # Create GPT partition table
    sgdisk -Z /dev/${disk}
    check_success "Disk zeroed successfully" "Failed to zero the disk"
    
    # Create partitions
    sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" /dev/${disk}
    sgdisk -n 2:0:+2G -t 2:8200 -c 2:"Linux swap" /dev/${disk}
    sgdisk -n 3:0:0 -t 3:8300 -c 3:"Linux filesystem" /dev/${disk}
    check_success "Partitions created successfully" "Failed to create partitions"
    
    # Wait for the system to recognize the new partitions
    sleep 2
    
    # Determine partition prefixes
    if [[ ${disk} == nvme* ]]; then
        boot_part="/dev/${disk}p1"
        swap_part="/dev/${disk}p2"
        root_part="/dev/${disk}p3"
    else
        boot_part="/dev/${disk}1"
        swap_part="/dev/${disk}2"
        root_part="/dev/${disk}3"
    fi
    
    # Format the partitions
    print_status "Formatting partitions..."
    
    mkfs.fat -F 32 ${boot_part}
    check_success "Boot partition formatted successfully" "Failed to format boot partition"
    
    mkswap ${swap_part}
    check_success "Swap partition formatted successfully" "Failed to format swap partition"
    
    swapon ${swap_part}
    check_success "Swap activated successfully" "Failed to activate swap"
    
    mkfs.btrfs -L archLinux ${root_part}
    check_success "Root partition formatted successfully" "Failed to format root partition"
    
    # Create and mount BTRFS subvolumes
    print_status "Creating BTRFS subvolumes..."
    
    mount ${root_part} /mnt
    
    # Create root subvolume
    btrfs subvolume create /mnt/@
    check_success "Root subvolume created successfully" "Failed to create root subvolume"
    
    # Create other subvolumes
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@snapshots
    btrfs subvolume create /mnt/@cache
    btrfs subvolume create /mnt/@log
    btrfs subvolume create /mnt/@tmp
    btrfs subvolume create /mnt/@docker
    check_success "Other subvolumes created successfully" "Failed to create subvolumes"
    
    # Unmount and remount with proper options
    umount /mnt
    
    # Mount options
    subvol_options="rw,noatime,compress-force=zstd:1,space_cache=v2"
    
    # Mount root subvolume
    mount -o ${subvol_options},subvol=@ ${root_part} /mnt
    check_success "Root subvolume mounted successfully" "Failed to mount root subvolume"
    
    # Create mount points
    mkdir -p /mnt/{boot,home,.snapshots,var/cache,var/log,var/tmp,var/lib/docker}
    
    # Mount other subvolumes
    mount -o ${subvol_options},subvol=@home ${root_part} /mnt/home
    mount -o ${subvol_options},subvol=@snapshots ${root_part} /mnt/.snapshots
    mount -o ${subvol_options},subvol=@cache ${root_part} /mnt/var/cache
    mount -o ${subvol_options},subvol=@log ${root_part} /mnt/var/log
    mount -o ${subvol_options},subvol=@tmp ${root_part} /mnt/var/tmp
    mount -o ${subvol_options},subvol=@docker ${root_part} /mnt/var/lib/docker
    check_success "Subvolumes mounted successfully" "Failed to mount subvolumes"
    
    # Mount boot partition
    mount ${boot_part} /mnt/boot
    check_success "Boot partition mounted successfully" "Failed to mount boot partition"
    
    # Install base system
    print_status "Installing base system..."
    
    # Detect CPU for microcode
    if grep -q "GenuineIntel" /proc/cpuinfo; then
        microcode="intel-ucode"
    elif grep -q "AuthenticAMD" /proc/cpuinfo; then
        microcode="amd-ucode"
    else
        microcode=""
        print_status "CPU vendor not detected. Microcode will not be installed."
    fi
    
    # Update package database
    pacman -Syy
    
    # Install base packages
    pacstrap /mnt base base-devel ${microcode} btrfs-progs linux linux-firmware networkmanager sudo
    check_success "Base system installed successfully" "Failed to install base system"
    
    # Generate fstab
    print_status "Generating fstab..."
    genfstab -U -p /mnt > /mnt/etc/fstab
    check_success "fstab generated successfully" "Failed to generate fstab"
    
    # Configure system
    print_status "Configuring system..."
    
    # Create a script to be executed inside chroot
    cat > /mnt/setup.sh << EOF
#!/bin/bash

# Set up timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Generate locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set hostname
echo "${hostname}" > /etc/hostname
cat > /etc/hosts << EOL
127.0.0.1 localhost
::1       localhost
127.0.1.1 ${hostname}.localdomain ${hostname}
EOL

# Set default editor
echo "EDITOR=nvim" > /etc/environment
echo "VISUAL=nvim" >> /etc/environment

# Set root password
echo "root:${root_password}" | chpasswd

# Create user
useradd -m -G wheel -s /bin/bash ${username}
echo "${username}:${user_password}" | chpasswd

# Configure sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager.service

# Install and configure bootloader
pacman -S --noconfirm grub efibootmgr grub-btrfs inotify-tools

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/boot --boot-directory=/boot --bootloader-id=GRUB

# Configure grub-btrfs
sed -i 's/#GRUB_BTRFS_GRUB_DIRNAME="\/boot\/grub"/GRUB_BTRFS_GRUB_DIRNAME="\/boot\/grub"/' /etc/default/grub-btrfs/config
systemctl enable grub-btrfsd.service

# Configure mkinitcpio
sed -i 's/^MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect modconf kms keyboard keymap consolefont block filesystems fsck grub-btrfs-overlayfs)/' /etc/mkinitcpio.conf

# Generate initramfs
mkinitcpio -P

# Generate GRUB config
grub-mkconfig -o /boot/grub/grub.cfg

# Install and configure Snapper
pacman -S --noconfirm snapper snap-pac

# Unmount .snapshots if mounted
mountpoint -q /.snapshots && umount /.snapshots
rm -rf /.snapshots

# Create Snapper config for root
snapper -c root create-config /

# Remove auto-created .snapshots subvolume
btrfs subvolume delete /.snapshots

# Re-create .snapshots directory and remount
mkdir /.snapshots
mount -a

# Set permissions
chmod 750 /.snapshots
chown :wheel /.snapshots

# Allow user to manage snapshots
sed -i "s/^ALLOW_USERS=\"\"/ALLOW_USERS=\"${username}\"/" /etc/snapper/configs/root

# Enable timeline and cleanup services
systemctl enable snapper-timeline.timer
systemctl enable snapper-cleanup.timer

# Enable SSD TRIM if needed
systemctl enable fstrim.timer

# Take initial snapshot
snapper -c root create -d "Base system snapshot"

EOF
    
    # Make the script executable
    chmod +x /mnt/setup.sh
    
    # Chroot and execute the script
    print_status "Entering chroot environment..."
    arch-chroot /mnt /setup.sh
    check_success "System configuration completed successfully" "Failed to configure system"
    
    # Cleanup
    rm /mnt/setup.sh
    
    # Unmount all partitions
    print_status "Unmounting partitions..."
    umount -R /mnt
    check_success "Partitions unmounted successfully" "Failed to unmount partitions"
    
    print_success "Installation complete! You can now reboot into your new Arch Linux system."
    print_status "Run 'reboot' to restart your system."
}

# Start the installation process
install_arch
