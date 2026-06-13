#!/usr/bin/env bash

# Make sure only root can run the script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update pacman repositories and upgrade packages
echo "Updating system packages..."
pacman -Syu --noconfirm

# Install pamac, an AUR helper, if not already installed
if ! command -v pamac &> /dev/null; then
    echo "Installing pamac..."
    pacman -S --noconfirm pamac
fi

# Update AUR packages
echo "Updating AUR packages..."
pamac upgrade -a --noconfirm

# Install missing language packs (adjust the search pattern as needed)
# WARNING: the glob can match many packages; review before running or narrow the pattern.
echo "Installing missing language packs..."
pacman -S --noconfirm $(pacman -Ssq '.*-lang$')

# Find the latest stable kernel version and install/update it
LATEST_KERNEL=$(pamac search -q -a --list | awk '/^linux[0-9]*\s+\S+\s+\S+-[0-9]+$/ {print $1}' | sort -V | tail -n 1)
if [ -z "$LATEST_KERNEL" ]; then
    echo "No stable kernel found. Please check your internet connection or package repositories."
    exit 1
fi
echo "Installing/updating to the latest stable kernel: $LATEST_KERNEL..."
pacman -S --noconfirm $LATEST_KERNEL

# Remove unused and old packages and dependencies
echo "Cleaning up old and unused packages..."
paccache -r
orphans=$(pacman -Qdtq || true)
[ -n "$orphans" ] && pacman -Rns $orphans

# Optimize Pacman database by cleaning up the package cache
echo "Optimizing Pacman database..."
paccache -ruk0

echo "All tasks completed successfully!"
