 Arch linux install guide
 -- Look at this: https://sharafat.pages.dev/archlinux-install/
    -- Still need to do docker and the other stuff here

## References:
### BTRFS with rollbach
1. (https://www.dwarmstrong.org/archlinux-install/ - Add docker btrfs partition /var/lib/docker) - (https://www.dwarmstrong.org/btrfs-snapshots-rollbacks/)

### Arch install script reference:
1. https://github.com/classy-giraffe/easy-arch/blob/main/easy-arch.sh
2. https://github.com/johnynfulleffect/ArchMatic
3. https://github.com/sayanchakroborty/arch-installer
4. https://github.com/mietinen/archer/blob/main/archer.sh

Can also do it in python. Might be easier

### Basic install guides (Ordered by throughness)
1. https://github.com/egara/arch-btrfs-installation
2. https://github.com/Zelrin/arch-btrfs-install-guide
3. https://gist.github.com/mjkstra/96ce7a5689d753e7a6bdd92cdc169bae - Good for after install

### Useful articles:
- https://www.lorenzobettini.it/2023/03/snapper-and-grub-btrfs-in-arch-linux/

## Look intos:
- https://github.com/egara/buttermanager

## Partitioning the disk
There is a required 2 partitions, one for the boot loader and another for the file system. Generally you should include another partition for the swap space.

| Partition | Size |
| :-: | :-: |
| Boot | 512M |
| Swap | Variable (Min: 2G) |
| Arch | Remaining |

### Partitioning with gdisk
You can also use cfdisk to do this:
```bash
gdisk /dev/${disk}
```
1) n (Make a new partition)
2) Enter (default partition number)
3) Enter (To start at default start)
4) +512 M (Size of boot)
5) Enter for default filetype
6) n
7) Enter
8) Enter
9) +2G (Size of swap)
10) Enter for default filetype
11) n
12) Enter
13) Enter
14) Enter 
15) Enter for default filetype
16) w to write and exit

### Format the partition types
```bash
mkfs.fat -F 32 /dev/${disk}1
mkswap /dev/${disk}2
mkfs.btrfs -L archLinux /dev/${disk}3
swapon /dev/${disk}2
```

## Btrfs subvolumes

Creating subvolumes separates the data, allowing for snapshots to be made for what is important. Thus, create subvolumes for directories that SHOULD NOT be in the snapshot of the system.

### Initial mount point and root subvolume

```bash
mount /dev/${disk}3 /mnt
btrfs subvolume create /mnt/@
```
### Create and mount the subvolumes

List of subvolumes to exclude
- @home - /home - This preserves user data, which generally does not destroy the system
- @snapshots - /.snapshots - For recursive purposes
- @cache - /var/cache - The cache is redundant
- @log - /var/log - This rolls back the system's log, which is useful in a system rollback
- @tmp - /var/tmp
- @docker - /var/lib/docker

#### Create the subvolumes
```bash
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots 
btrfs subvolume create /mnt/@cache
btrfs subvolume create /mnt/@log 
btrfs subvolume create /mnt/@tmp
btrfs subvolume create /mnt/@docker
```

#### Mount the subvolumes

Unmount the root partition and setup the mount options:
- noatime - Increases performance and reduces SSD writes
- compress-force=zstd:1 - only for NVME devices
- space_cache=v2 - Improves performance by placing cache in memory
```bash
umount /mnt
export subvol_options="rw,noatime,compress-force=zstd:1,space_cache=v2"
```

Create the required mount points
```bash
mount -o ${subvol_options},subvol=@ /dev/${disk}3 /mnt
mkdir -p /mnt/{boot,home,.snapshots,var/cache,var/log,var/tmp,var/lib/docker}
```

Mount the subvolumes
```bash
mount -o ${subvol_options},subvol=@home /dev/${disk}3 /mnt/home 
mount -o ${subvol_options},subvol=@snapshots /dev/${disk}3 /mnt/.snapshots 
mount -o ${subvol_options},subvol=@cache /dev/${disk}3 /mnt/var/cache
mount -o ${subvol_options},subvol=@log /dev/${disk}3 /mnt/var/log 
mount -o ${subvol_options},subvol=@tmp /dev/${disk}3 /mnt/var/tmp
mount -o ${subvol_options},subvol=@docker /dev/${disk}3 /mnt/var/lib/docker
mount /dev/${disk}1 /mnt/boot
```
## Install the Base system

Get the correct cpu architecture
```bash
grep vendor_id /proc/cpuinfo
	export microcode="amd-ucode"
	OR
	export microcode="intel-ucode"
```

Install the base system
```bash
pacman -Syy
pacstrap /mnt base base-devel ${microcode} btrfs-progs linux linux-firmware networkmanager
```

Generate the fstab and go into the filesystem
```bash
genfstab -U -p /mnt > /mnt/etc/fstab
arch-chroot /mnt
```

Setup the time-zone
```bash
ln -sf /usr/share/zoneinfo/Africa/Johannesburg /etc/localtime
hwclock --systohc
```

Generate the locale
```bash
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen
```

Specify the hostname
```bash
echo "glasPal6" > /etc/hostname
cat > /etc/hosts << EOF
127.0.0.1 localhost 
::1 localhost 
127.0.1.1 glasPal6.localdomain glasPal6
EOF
```

Set a system-wide default editor
```bash
echo "EDITOR=nvim" > /etc/environment && echo "VISUAL=nvim" >> /etc/environment
```

Assign a password to the root and add a user
```bash
passwd
useradd -m -G wheel -s /bin/bash dyl
passwd dyl
sed -i "s/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
```

Enable the network manager
```bash
systemctl enable NetworkManager.service
```

## Boot manager

Install the grub boot manager
```bash
pacman -S grub efibootmgr grub-btrfs inotify-tools
```

Install grub in the ESP
```bash
grub-install --target=x86_64-efi --efi-directory=/boot --boot-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

Set the location of the boot directory in `/etc/default/grub-btrfs/config`
- Should be default
```bash
sed -i 's/#GRUB_BTRFS_GRUB_DIRNAME="/boot/grub"/GRUB_BTRFS_GRUB_DIRNAME="/boot/grub"' /etc/default/grub-btrfs/config
```

Allow grub-btrfs to auto-generate a config file whenever a change happens in .snapshots
```bash
sudo systemctl enable grub-btrfsd.service
```

Housekeeping to include btrfs
```bash
nvim /etc/mkinincpio.conf
```
and add `btrfs` to `MODULES`, and make sure `HOOKS` looks like
```bash
HOOKS=(... grub-btrfs-overlayfs)
```
then recreate the file
```bash
mkinitcpio -P
```

Exit and reboot
```bash
exit
umount -R /mnt
reboot
```

## Things to do after the first install

### Sudo privileges and Pacman

Add colour to the package manager
- Add `Color` to `/etc/pacman.conf` under Misc options and ParallelDownloads
- Run `sudo pacman -Syu` to update the system

```bash
sudo sed -i '/#Color/Color' /etc/pacman.conf
sudo sed -i '/#ParallelDownloads/ParallelDownloads' /etc/pacman.conf
```

### Use TRIM for SSD storage

Enable a weekly task that discards unused blocks on the drive
```bash
sudo systemctl enable fstrim.timer
```

### Setup sound

```bash
sudo pacman -S pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber alsa-utils
```

Test with after a reboot
```bash
pactl info | grep Pipe 
speaker-test -c 2 -t wav -l 1
```
### Install PARU for the AUR

Install paru for easy access to AUR packages
```bash
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd .. ; sudo rm -r paru
paru
```

### Other Packages

```bash
sudo pacman -S libnotify htop man-db neovim networkmanager git fwupd
```

### Grub Timeout

Edit the `/etc/default/grub` to remove the grub menu. This will then be shown if you hold the shift key
```bash
grep -q '^GRUB_FORCE_HIDDEN_MENU="true"' /etc/default/grub || \
echo 'GRUB_FORCE_HIDDEN_MENU="true"' | sudo tee -a /etc/default/grub
```

Then create this file
```bash
sudo tee /etc/grub.d/31_hold_shift > /dev/null <<'EOF'
#! /bin/sh
set -e

prefix="/usr"
exec_prefix="${prefix}"
datarootdir="${prefix}/share"

export TEXTDOMAIN=grub
export TEXTDOMAINDIR="${datarootdir}/locale"
source "${datarootdir}/grub/grub-mkconfig_lib"

found_other_os=

make_timeout () {

  if [ "x${GRUB_FORCE_HIDDEN_MENU}" = "xtrue" ] ; then
    if [ "x${1}" != "x" ] ; then
      if [ "x${GRUB_HIDDEN_TIMEOUT_QUIET}" = "xtrue" ] ; then
    verbose=
      else
    verbose=" --verbose"
      fi

      if [ "x${1}" = "x0" ] ; then
    cat <<EOF
if [ "x\${timeout}" != "x-1" ]; then
  if keystatus; then
    if keystatus --shift; then
      set timeout=-1
    else
      set timeout=0
    fi
  else
    if sleep$verbose --interruptible 3 ; then
      set timeout=0
    fi
  fi
fi
EOF
      else
    cat << EOF
if [ "x\${timeout}" != "x-1" ]; then
  if sleep$verbose --interruptible ${GRUB_HIDDEN_TIMEOUT} ; then
    set timeout=0
  fi
fi
EOF
      fi
    fi
  fi
}

adjust_timeout () {
  if [ "x$GRUB_BUTTON_CMOS_ADDRESS" != "x" ]; then
    cat <<EOF
if cmostest $GRUB_BUTTON_CMOS_ADDRESS ; then
EOF
    make_timeout "${GRUB_HIDDEN_TIMEOUT_BUTTON}" "${GRUB_TIMEOUT_BUTTON}"
    echo else
    make_timeout "${GRUB_HIDDEN_TIMEOUT}" "${GRUB_TIMEOUT}"
    echo fi
  else
    make_timeout "${GRUB_HIDDEN_TIMEOUT}" "${GRUB_TIMEOUT}"
  fi
}

  adjust_timeout

    cat <<EOF
if [ "x\${timeout}" != "x-1" ]; then
  if keystatus; then
    if keystatus --shift; then
      set timeout=-1
    else
      set timeout=0
    fi
  else
    if sleep$verbose --interruptible 3 ; then
      set timeout=0
    fi
  fi
fi
EOF
```

Then make it executable and regenerate the grub config
```bash
sudo chmod +x /etc/grub.d/31_hold_shift
grub-mkconfig -o /boot/grub/grub.cfg
```

### Install sddm and hyprland

#### Install SDDM (Simple Desktop Display Manager)

Install SDDM:
```bash
sudo pacman -S sddm
```

Enable SDDM to start on boot:
```bash
sudo systemctl enable sddm
```

Optionally, you can install a theme for SDDM:
```bash
sudo pacman -S sddm-kcm
```
This allows you to configure SDDM themes via KDE System Settings.

#### Install Hyprland (Wayland Compositor)

Install Hyprland and its dependencies:
```bash
sudo pacman -S hyprland wayland xorg-xwayland wl-clipboard grim slurp mako wofi alacritty
```

Optionally, install additional tools for a better experience:
```bash
sudo pacman -S swaybg swaylock swayidle
```

Set up the environment for Hyprland:
1. Add the following to your `~/.bash_profile` or `~/.zshrc`:
   ```bash
   export XDG_SESSION_TYPE=wayland
   export GDK_BACKEND=wayland
   export QT_QPA_PLATFORM=wayland
   export CLUTTER_BACKEND=wayland
   export SDL_VIDEODRIVER=wayland
   export _JAVA_AWT_WM_NONREPARENTING=1
   export WLR_NO_HARDWARE_CURSORS=1
   ```

2. Create a basic Hyprland configuration file:
   ```bash
   mkdir -p ~/.config/hypr
   cp /etc/hypr/hyprland.conf ~/.config/hypr/hyprland.conf
   ```

3. Start Hyprland by adding it to your `.xinitrc`:
   ```bash
   exec Hyprland
   ```

After rebooting, SDDM will handle the login, and you can select Hyprland as your session.

- Install a terminal emulator (e.g., Alacritty or Kitty):
  ```bash
  sudo pacman -S alacritty
  ```

- Install a compositor-friendly file manager (e.g., Thunar):
  ```bash
  sudo pacman -S thunar
  ```

- Install a notification daemon (e.g., Mako):
  ```bash
  sudo pacman -S mako
  ```

- Customize Hyprland further by editing `~/.config/hypr/hyprland.conf`.

## Custom software that I use

- wezterm
- neovim
- zsh
- btop
- tmux
- Zen
- Discord
- Okular with jabref
- bear or compiledb
- ncdu
- starship
- lazygit
- lazydocker
- fzf
- poetry
- zoxide
- eza
- fd
- sshfs

## Setup snapshots with snapper

### Install snapper
Install snapper
```bash
sudo pacman -S snapper snap-pac
```

Umount .snapshots and remove the mount point to allow snapper to create a config
```bash
sudo umount /.snapshots
sudo rm -rf /.snapshots
sudo snapper -c root create-config / # creats a .snapshots directory
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -a
sudo chmod 750 /.snapshots
sudo chown :wheel /.snapshots
```

Take a snapshot of the base system
```bash
sudo snapper -c root create -d "**Base system**"
```

Modify the configs in `/etc/snapper/configs/root` to allow the user to work with snapshots
```bash
ALLOW_USER="dyl"
```
and to take snapshots when wanted

Automate the taking and cleaning of the snapshots
```bash
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

### System rollbacks

Boot into a snapshot, taking note of the snapshot number that you want to go back to
Then
```bash
sudo mount /dev/${disk}3 /mnt
	sudo mv /mnt/@ /mnt/@.broken
		OR
	sudo btrfs subvolume delete /mnt/@
```

Get the number of the snapshot that you want to roll back to
```bash
sudo grep -r '<date>' /mnt/@snapshots/*/info.xml
```

Rollback the system
```bash
sudo btrfs subvolume snapshot /mnt/@snapshots/{number}/snapshot /mnt/@
sudo umount /mnt
reboot
```

Do any cleanup necessary

