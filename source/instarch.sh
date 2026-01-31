#!/usr/bin/env bash

# Instarch - the simple Arch installer

set -euo pipefail
IFS=$'\n\t'
SHELL_BIN=/bin/sh
EXIT_ON_ERROR=true
VERBOSE=false # Print command before running.

# Configure your stuff here as needed (disk identifiers, etc.)
# ____________________________________________________________
#
# [WARNING] Make sure your disk identifiers are correct! If
# they are incorrect, it is very easy to lose data. Be careful.
ROOTPART=/dev/vda1  # Root partition.
BOOTPART=/dev/vda2  # Boot partition, where GRUB will be installed.
# ____________________________________________________________

commandsParent=(
  "mkfs.fat -F32 $BOOTPART"                                      # Format boot partition
  "mkfs.ext4 $ROOTPART"                                           # Format root partition
  "mount $ROOTPART /mnt"                                          # Mount root partition
  "mount --mkdir $BOOTPART /mnt/boot"                              # Mount boot partition

  # Install base system
  "pacstrap -K /mnt base linux linux-firmware"                    # Install base packages

  # Generate fstab
  "genfstab -U /mnt >> /mnt/etc/fstab"                            # Generate fstab

  # Chroot into the new system to configure it
  "arch-chroot /mnt bash -c '"

  # Set timezone
  "ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime"       # Change timezone as needed
  "hwclock --systohc"                                             # Set system clock

  # Set locale
  "echo \"en_US.UTF-8 UTF-8\" >> /etc/locale.gen"                 # Enable locale
  "locale-gen"
  "echo \"LANG=en_US.UTF-8\" > /etc/locale.conf"                   # Set LANG variable

  # Set hostname
  "echo \"arch\" > /etc/hostname"                                  # Set hostname

  # Set root password (prompt for it)
  "echo \"Set root password\""
  "passwd"

  # Install bootloader
  "pacman -S grub efibootmgr networkmanager --noconfirm"           # Install GRUB and other essential packages
  "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB" # Install GRUB bootloader
  "grub-mkconfig -o /boot/grub/grub.cfg"                          # Generate GRUB config

  # Enable NetworkManager (for network management)
  "systemctl enable NetworkManager"

  # Create user and set password
  "echo \"Enter username for non-root user: \""
  "read -r username"
  "useradd -m -G wheel $username"                                 # Create user
  "passwd $username"                                              # Set password for user

  # Exit chroot
  "exit"

  # Exit from chroot environment
  "umount -R /mnt"                                                # Unmount all partitions

  # Final message
  "echo [OK] Install finished. Please reboot."
)

# Execute commands
for cmd in "${commandsParent[@]}"; do
  if [ "$VERBOSE" = true ]; then
    echo "$cmd"
  fi
  eval "$cmd"
done

