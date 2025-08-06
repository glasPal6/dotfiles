#!/bin/bash

# Arch Linux Automated Install Script
# Author: Adapted from user-provided install guide
# WARNING: This will erase all data on the selected disk

set -euo pipefail

# === CONFIGURATION ===
read -rp "Enter target disk (e.g., /dev/sda or /dev/nvme0n1): " disk
read -rp "Enter hostname for this system: " hostname
read -rp "Enter username for the new user: " username
timezone="Africa/Johannesburg"
locale="en_US.UTF-8"
boot_size="+512M"
swap_size="+2G"

# === PARTITIONING ===
echo "Partitioning disk: $disk"
sgdisk -Z "$disk"
sgdisk -n1:0:"$boot_size" -t1:ef00 "$disk"      # EFI
sgdisk -n2:0:"$swap_size" -t2:8200 "$disk"      # SWAP
sgdisk -n3:0:0 -t3:8300 "$disk"                 # BTRFS

boot="${disk}1"
swap="${disk}2"
root="${disk}3"

# === FORMAT AND MOUNT ===
echo "Formatting and mounting partitions..."
mkfs.fat -F32 "$boot"
mkswap "$swap"
swapon "$swap"
mkfs.btrfs -L archLinux "$root"

# Mount and create subvolumes
mount "$root" /mnt
for sub in @ @home @snapshots @cache @log @tmp @docker; do
    btrfs subvolume create /mnt/$sub
done
umount /mnt

# Mount with options
opts="rw,noatime,compress-force=zstd:1,space_cache=v2"
mount -o $opts,subvol=@ "$root" /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/cache,var/log,var/tmp,var/lib/docker}

mount -o $opts,subvol=@home "$root" /mnt/home
mount -o $opts,subvol=@snapshots "$root" /mnt/.snapshots
mount -o $opts,subvol=@cache "$root" /mnt/var/cache
mount -o $opts,subvol=@log "$root" /mnt/var/log
mount -o $opts,subvol=@tmp "$root" /mnt/var/tmp
mount -o $opts,subvol=@docker "$root" /mnt/var/lib/docker
mount "$boot" /mnt/boot

# === BASE SYSTEM INSTALL ===
echo "Installing base system..."
grep -q "AuthenticAMD" /proc/cpuinfo && ucode="amd-ucode" || ucode="intel-ucode"

pacman -Syy
pacstrap /mnt base base-devel "$ucode" btrfs-progs linux linux-firmware htop man-db neovim networkmanager git fwupd

# === FSTAB, CHROOT ===
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF

# Set timezone and locale
ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc

echo "$locale UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=$locale" > /etc/locale.conf

# Hostname and hosts
echo "$hostname" > /etc/hostname
cat <<HOSTS > /etc/hosts
127.0.0.1 localhost
::1       localhost
127.0.1.1 $hostname.localdomain $hostname
HOSTS

# Editor
echo "EDITOR=nvim" >> /etc/environment
echo "VISUAL=nvim" >> /etc/environment

# Users
echo "Set root password:"
passwd
useradd -m -G wheel -s /bin/bash $username
echo "Set password for user '$username':"
passwd $username
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager

# === BOOTLOADER INSTALLATION ===
pacman -S --noconfirm grub efibootmgr grub-btrfs inotify-tools
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# Grub-btrfs config
sed -i 's/#GRUB_BTRFS_GRUB_DIRNAME="/boot/grub"/GRUB_BTRFS_GRUB_DIRNAME="/boot/grub"/' /etc/default/grub-btrfs/config
systemctl enable grub-btrfsd.service

# Add btrfs module to mkinitcpio
sed -i '/^MODULES/s/()/btrfs/' /etc/mkinitcpio.conf
if ! grep -q 'grub-btrfs-overlayfs' /etc/mkinitcpio.conf; then
  sed -i '/^HOOKS/s/)/ grub-btrfs-overlayfs)/' /etc/mkinitcpio.conf
fi
mkinitcpio -P

EOF

# === FINALIZE ===
echo "Installation complete. Unmounting and rebooting..."
umount -R /mnt
reboot

