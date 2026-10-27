#!/usr/bin/env bash
set -e

# Update Manjaro packages + AUR
pamac update --aur --enable-downgrade --force-refresh --no-confirm

# Update system-wide Flatpaks
sudo flatpak update --system --assumeyes

# Update user Flatpaks
flatpak update --user --assumeyes

# Remove unused Flatpak dependencies
sudo flatpak uninstall --system --unused --assumeyes
flatpak uninstall --user --unused --assumeyes

echo "All updates completed successfully!"

