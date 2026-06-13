#!/usr/bin/env bash
# Simple UFW baseline for Debian/Ubuntu. Requires root/sudo.

sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable
