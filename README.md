## xNxP Linux Scripts

Small personal collection of Linux admin/maintenance scripts.

**Review before use.** Most do privileged package work and assume internet. Some are old or very specific. Distro-specific scripts are named accordingly.

### Scripts

**Distro-specific (apt / Debian family)**
- `shutdown-ubuntu.bash` — Full upgrade (apt + snap), clean, then `poweroff`.
- `postinstall-ubuntu.bash` — Large post-fresh-install package list (historical; many entries outdated).
- `server-ubuntu.bash` — Notes / manual commands for basic server setup (not a turnkey script).
- `ufw-ubuntu.bash` — Quick UFW baseline (deny incoming, allow ssh/http/https).

**Distro-specific (pacman / Manjaro)**
- `update-manjaro.bash` — System + AUR upgrade, language packs (careful), kernel update attempt, cleanup. **Run as root.**

**General / task-specific**
- `save-battery.bash` — `powertop --auto-tune` + powersave governor (laptops).
- `meteor-start.bash` — Launcher for a Meteor bundle at `~/bundle` (edit ports/URLs inside).
- `install_stuff.pp` — Tiny Puppet example (nginx + Node + Mongo).

### Usage
- Run directly: `bash <script>.bash`
- Or make executable once: `chmod +x *.bash` then `./<script>.bash`
- Edit the scripts to fit your packages, kernel preferences, ports, etc.
- For shutdown-ubuntu and update-manjaro: they will reboot/poweroff or change system state — know what you're doing.

Originally started as a weekly "update and shutdown" helper. Kept simple.
