#!/usr/bin/env bash

echo "=== Updating system + AUR ===" &&
pamac update --aur --enable-downgrade --force-refresh --no-confirm &&

echo "=== Updating Flatpaks ===" &&
flatpak update --assumeyes &&

echo "=== Cleaning unused Flatpaks ===" &&
flatpak uninstall --unused --assumeyes &&

echo "=== Removing orphans ===" &&
pamac remove --orphans --no-confirm || true &&   # || true so it doesn't stop if no orphans

echo "=== Cleaning package cache ===" &&
pamac clean --no-confirm -k 2 &&

echo "=== Cleaning old AUR build files ===" &&
pamac clean --buildfiles --no-confirm || true &&

echo "=== Update complete! ==="
