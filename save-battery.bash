#!/usr/bin/env bash
# Aggressive power saving for laptops.
# WARNING: This will temporarily break audio, unload ethernet (r8169) and webcam (uvcvideo),
#          and stop Docker. Only use when you want maximum battery/runtime.

echo "Applying power saving tweaks..."

echo "Current CPU governor(s):"
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null | sort | uniq -c || echo "  (unable to read)"

sudo powertop --auto-tune
sudo cpupower frequency-set -g powersave

echo "Governor after change:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "  (unable to read)"

# Unload Realtek ethernet driver (saves power when on WiFi)
echo "Unloading ethernet driver (r8169)..."
sudo modprobe -r r8169 || true

# Stop PipeWire audio stack (one of the bigger power consumers)
echo "Stopping audio (PipeWire)..."
systemctl --user stop pipewire.socket pipewire-pulse.socket
systemctl --user stop pipewire pipewire-pulse wireplumber

# Unload USB webcam driver
echo "Unloading webcam driver (uvcvideo)..."
sudo modprobe -r uvcvideo || true

# Give services a moment to settle, then restart audio
sleep 2
echo "Restarting audio..."
systemctl --user start wireplumber pipewire pipewire-pulse

# Stop Docker completely
echo "Stopping Docker..."
sudo systemctl stop docker.socket
sudo systemctl stop docker.service

echo "Power saving steps applied."
echo "To restore ethernet + webcam later: sudo modprobe r8169 uvcvideo"
