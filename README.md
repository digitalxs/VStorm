# VStorm

VSCodium configured to work like PhpStorm / WebStorm, for PHP (Laravel, Symfony,
Drupal, WordPress, Joomla) and JS/TS work, with FileZilla-style remote file management.

**Supported systems: Debian 13 and Arch Linux only.** The installer refuses to run anywhere else
(including derivatives such as Ubuntu, Mint, Manjaro).

## Install

```bash
git clone https://github.com/digitalxs/VStorm.git
cd VStorm
./install.sh
```

Run it as your normal user; it uses `sudo` where needed. Options:

| Flag | Effect |
|---|---|
| `--no-packages` | Config, menu entry and extensions only (no apt/pacman) |
| `--no-extensions` | Skip extension installs |
| `--with-filezilla` | Also install the FileZilla GUI client |

What it does:

1. Installs VSCodium (Debian: official apt repo; Arch: `vscodium-bin` from the AUR via yay/paru/makepkg).
2. Installs PHP + extensions, Composer, Xdebug, Node/npm, MariaDB client, SQLite, JetBrains Mono.
3. Configures Xdebug (port 9003, starts on trigger) and, on Arch, enables the PHP extensions CMSes need.
4. Installs global Composer tools: PHPStan, PHP-CS-Fixer, Pint, PHPCS with WordPress and Drupal standards.
5. Writes `settings.json`, `keybindings.json` and CMS snippets to `~/.config/VSCodium/User/` (existing files are backed up as `*.bak.<timestamp>`).
6. Installs the extension set in `config/extensions.txt` from Open VSX.
7. Adds a **VStorm** entry (Development) to the KDE / XFCE menu, with icon.

Per project, run `vstorm-init` to add Xdebug launch configs, tasks (composer, artisan, console, drush, wp, npm, PHPUnit, PHPStan), `.editorconfig` and a sample `.http` file.

Remove the menu entry and helpers with `./uninstall.sh`.

## Notes

- Keymap: IntelliJ IDEA keybindings plus extras in `config/keybindings.json`. Format is `Ctrl+Alt+Shift+L` because `Ctrl+Alt+L` locks the screen on XFCE/KDE.
- Extensions come from Open VSX. Any ID not found there is skipped and listed at the end of install; edit `config/extensions.txt` to adjust.
- See [docs/FEATURE-MAP.md](docs/FEATURE-MAP.md) for the PhpStorm feature mapping and what cannot be matched.
