#!/usr/bin/env bash
# VStorm installer: turns VSCodium into a PhpStorm/WebStorm-style PHP & web IDE.
# Supported: Debian 13 (trixie) and Arch Linux. Everything else is refused.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/VSCodium/User"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
BIN_DIR="$HOME/.local/bin"

DO_PACKAGES=1
DO_EXTENSIONS=1
WITH_FILEZILLA=0

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m  %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<EOF
Usage: ./install.sh [options]

  --no-packages     don't install system packages / VSCodium (config only)
  --no-extensions   don't install extensions
  --with-filezilla  also install the FileZilla GUI client
  -h, --help        show this help

Supported systems: Debian 13 and Arch Linux only.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --no-packages)    DO_PACKAGES=0 ;;
    --no-extensions)  DO_EXTENSIONS=0 ;;
    --with-filezilla) WITH_FILEZILLA=1 ;;
    -h|--help)        usage; exit 0 ;;
    *) usage; die "unknown option: $arg" ;;
  esac
done

# ---------------------------------------------------------------- OS gate --
[[ "$(uname -s)" == "Linux" ]] || die "VStorm only supports Debian 13 and Arch Linux."
[[ -r /etc/os-release ]] || die "Cannot detect OS (/etc/os-release missing). Debian 13 and Arch Linux only."
OS_ID="$(. /etc/os-release; echo "${ID:-}")"
OS_VER="$(. /etc/os-release; echo "${VERSION_ID:-}")"
case "$OS_ID" in
  debian) [[ "$OS_VER" == "13" ]] || die "Debian $OS_VER is not supported. Debian 13 only." ;;
  arch)   ;;
  *)      die "Unsupported OS '$OS_ID'. VStorm supports Debian 13 and Arch Linux only (derivatives included in the refusal)." ;;
esac
[[ $EUID -ne 0 ]] || die "Run as your normal user, not root. sudo is requested when needed."
command -v sudo >/dev/null || die "sudo is required."
info "Detected: $OS_ID ${OS_VER:+$OS_VER}"

# --------------------------------------------------------------- packages --
install_vscodium_debian() {
  command -v codium >/dev/null && return
  info "Adding the VSCodium apt repository"
  sudo install -d -m 0755 /usr/share/keyrings
  curl -fsSL https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg \
    | gpg --dearmor | sudo tee /usr/share/keyrings/vscodium-archive-keyring.gpg >/dev/null
  sudo tee /etc/apt/sources.list.d/vscodium.sources >/dev/null <<'EOF'
Types: deb
URIs: https://download.vscodium.com/debs
Suites: vscodium
Components: main
Architectures: amd64 arm64
Signed-by: /usr/share/keyrings/vscodium-archive-keyring.gpg
EOF
  sudo apt-get update
  sudo apt-get install -y codium
}

install_vscodium_arch() {
  command -v codium >/dev/null && return
  command -v vscodium >/dev/null && return
  info "Installing vscodium-bin from the AUR"
  if command -v yay >/dev/null; then
    yay -S --needed --noconfirm vscodium-bin
  elif command -v paru >/dev/null; then
    paru -S --needed --noconfirm vscodium-bin
  else
    local tmp; tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/vscodium-bin.git "$tmp/vscodium-bin"
    (cd "$tmp/vscodium-bin" && makepkg -si --noconfirm)
    rm -rf "$tmp"
  fi
}

install_packages_debian() {
  info "Installing PHP, Node, database clients and fonts (apt)"
  sudo apt-get update
  sudo apt-get install -y ca-certificates curl gnupg git unzip jq desktop-file-utils \
    php-cli php-xml php-mbstring php-curl php-zip php-gd php-intl php-bcmath \
    php-mysql php-sqlite3 php-xdebug composer nodejs npm \
    mariadb-client sqlite3 fonts-jetbrains-mono
  (( WITH_FILEZILLA )) && sudo apt-get install -y filezilla
  install_vscodium_debian
}

install_packages_arch() {
  info "Installing PHP, Node, database clients and fonts (pacman)"
  sudo pacman -Sy --needed --noconfirm base-devel git curl unzip jq desktop-file-utils \
    php php-gd php-intl composer xdebug nodejs npm \
    mariadb-clients sqlite ttf-jetbrains-mono
  (( WITH_FILEZILLA )) && sudo pacman -S --needed --noconfirm filezilla
  install_vscodium_arch
  enable_arch_php_extensions
}

# Arch ships php.ini with extensions commented out; enable what Laravel/Drupal/WP need.
enable_arch_php_extensions() {
  local ini=/etc/php/php.ini ext
  [[ -f $ini ]] || return 0
  info "Enabling PHP extensions in $ini (backup: $ini.vstorm.bak)"
  [[ -f $ini.vstorm.bak ]] || sudo cp "$ini" "$ini.vstorm.bak"
  for ext in bcmath curl gd iconv intl mysqli pdo_mysql pdo_sqlite sodium sqlite3 zip; do
    sudo sed -i "s/^;extension=${ext}\$/extension=${ext}/" "$ini"
  done
}

configure_xdebug() {
  local body dirs=() d
  body=$'; Written by VStorm\nxdebug.mode=debug,develop\nxdebug.start_with_request=trigger\nxdebug.client_host=127.0.0.1\nxdebug.client_port=9003\n'
  if [[ $OS_ID == arch ]]; then
    php -m 2>/dev/null | grep -qi '^xdebug$' || body=$'zend_extension=xdebug\n'"$body"
    dirs=(/etc/php/conf.d)
  else
    for d in /etc/php/*/cli/conf.d /etc/php/*/fpm/conf.d /etc/php/*/apache2/conf.d; do
      [[ -d $d ]] && dirs+=("$d")
    done
  fi
  for d in "${dirs[@]}"; do
    printf '%s' "$body" | sudo tee "$d/99-vstorm-xdebug.ini" >/dev/null
  done
  info "Xdebug configured (listens on 9003, starts on trigger)"
}

COMPOSER_BIN=""
install_composer_tools() {
  info "Installing global Composer tools (phpstan, php-cs-fixer, phpcs, Pint, WP/Drupal standards)"
  composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true || true
  local pkg
  for pkg in phpstan/phpstan friendsofphp/php-cs-fixer laravel/pint squizlabs/php_codesniffer \
             dealerdirect/phpcodesniffer-composer-installer phpcompatibility/php-compatibility \
             wp-coding-standards/wpcs drupal/coder; do
    composer global require --no-interaction --quiet "$pkg" || warn "composer: could not install $pkg"
  done
}

resolve_composer_bin() {
  if command -v composer >/dev/null; then
    COMPOSER_BIN="$(composer global config bin-dir --absolute 2>/dev/null || true)"
  fi
  [[ -n $COMPOSER_BIN ]] || COMPOSER_BIN="$HOME/.config/composer/vendor/bin"
}

if (( DO_PACKAGES )); then
  "install_packages_$OS_ID"
  configure_xdebug
  install_composer_tools
fi
resolve_composer_bin

CODIUM="$(command -v codium || command -v vscodium || true)"
[[ -n $CODIUM ]] || die "VSCodium not found. Re-run without --no-packages."
CODIUM="$(basename "$CODIUM")"

# ----------------------------------------------------------------- config --
install_config() {
  info "Installing settings, keybindings and snippets into $USER_DIR"
  mkdir -p "$USER_DIR/snippets"
  local stamp f
  stamp="$(date +%Y%m%d-%H%M%S)"
  for f in settings.json keybindings.json; do
    [[ -f $USER_DIR/$f ]] && cp "$USER_DIR/$f" "$USER_DIR/$f.bak.$stamp"
  done
  sed -e "s|@HOME@|$HOME|g" -e "s|@COMPOSER_BIN@|$COMPOSER_BIN|g" \
    "$REPO_DIR/config/settings.json.tpl" > "$USER_DIR/settings.json"
  cp "$REPO_DIR/config/keybindings.json" "$USER_DIR/keybindings.json"
  cp "$REPO_DIR/config/snippets/"*.code-snippets "$USER_DIR/snippets/"
}

install_helpers() {
  info "Installing project templates and vstorm-init"
  mkdir -p "$BIN_DIR" "$DATA_DIR/vstorm"
  rm -rf "$DATA_DIR/vstorm/templates"
  cp -r "$REPO_DIR/templates" "$DATA_DIR/vstorm/templates"
  install -m 0755 "$REPO_DIR/bin/vstorm-init" "$BIN_DIR/vstorm-init"
}

install_desktop_entry() {
  info "Adding the VStorm menu entry (KDE / XFCE / any freedesktop menu)"
  mkdir -p "$DATA_DIR/applications" "$DATA_DIR/icons/hicolor/scalable/apps"
  cp "$REPO_DIR/desktop/vstorm.svg" "$DATA_DIR/icons/hicolor/scalable/apps/vstorm.svg"
  sed "s|@CODIUM@|$CODIUM|g" "$REPO_DIR/desktop/vstorm.desktop.tpl" > "$DATA_DIR/applications/vstorm.desktop"
  chmod +x "$DATA_DIR/applications/vstorm.desktop"
  command -v desktop-file-validate >/dev/null && desktop-file-validate "$DATA_DIR/applications/vstorm.desktop" || true
  command -v update-desktop-database >/dev/null && update-desktop-database "$DATA_DIR/applications" 2>/dev/null || true
  command -v gtk-update-icon-cache >/dev/null && gtk-update-icon-cache -q -t "$DATA_DIR/icons/hicolor" 2>/dev/null || true
  # Refresh the KDE menu cache (Plasma 6, then 5) so it shows up without re-login.
  if   command -v kbuildsycoca6 >/dev/null; then kbuildsycoca6 >/dev/null 2>&1 || true
  elif command -v kbuildsycoca5 >/dev/null; then kbuildsycoca5 >/dev/null 2>&1 || true
  fi
  case "${XDG_CURRENT_DESKTOP:-}" in
    *KDE*|*XFCE*|*Xfce*) ;;
    *) warn "KDE/XFCE not detected (XDG_CURRENT_DESKTOP='${XDG_CURRENT_DESKTOP:-}'); the entry is still installed." ;;
  esac
}

install_extensions() {
  info "Installing extensions from Open VSX (this takes a while)"
  local id failed=() ok=0
  while IFS= read -r id; do
    id="${id%%#*}"; id="${id//[[:space:]]/}"
    [[ -n $id ]] || continue
    if "$CODIUM" --install-extension "$id" --force >/dev/null 2>&1; then
      ok=$((ok + 1))
    else
      failed+=("$id")
    fi
  done < "$REPO_DIR/config/extensions.txt"
  info "Extensions installed: $ok"
  if (( ${#failed[@]} )); then
    warn "Not found on Open VSX or failed (non-fatal): ${failed[*]}"
  fi
}

install_config
install_helpers
install_desktop_entry
(( DO_EXTENSIONS )) && install_extensions

cat <<EOF

VStorm is installed. Launch it from the application menu (Development > VStorm)
or run: $CODIUM

In a project, run 'vstorm-init' to add Xdebug launch configs, tasks and .editorconfig.
Make sure $BIN_DIR is on your PATH for the vstorm-init command.
EOF
