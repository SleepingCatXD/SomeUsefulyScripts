#!/bin/bash
sudo sbctl create-keys
sudo sbctl enroll-keys -m
sudo sbctl sign -s /boot/EFI/ArchGrub/grubx64.efi
sudo sbctl sign -s /boot/EFI/Boot/bootx64.efi
sudo sbctl sign -s /boot/vmlinuz-linux-zen
sudo sbctl sign -s /boot/grub/x86_64-efi/grub.efi
sudo sbctl sign -s /boot/grub/x86_64-efi/core.efi
sudo sbctl status
