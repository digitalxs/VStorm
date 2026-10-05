#!/usr/bin/env bash
# Removes the VStorm menu entry, icon and helpers. Leaves VSCodium, system
# packages, extensions and your settings.json untouched (backups remain next to it).
set -euo pipefail

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"

rm -fv "$DATA_DIR/applications/vstorm.desktop" \
       "$DATA_DIR/icons/hicolor/scalable/apps/vstorm.svg" \
       "$HOME/.local/bin/vstorm-init"
rm -rfv "$DATA_DIR/vstorm"

command -v update-desktop-database >/dev/null && update-desktop-database "$DATA_DIR/applications" 2>/dev/null || true
if   command -v kbuildsycoca6 >/dev/null; then kbuildsycoca6 >/dev/null 2>&1 || true
elif command -v kbuildsycoca5 >/dev/null; then kbuildsycoca5 >/dev/null 2>&1 || true
fi
echo "Done. To restore your old settings, use the settings.json.bak.* files in ~/.config/VSCodium/User/."
