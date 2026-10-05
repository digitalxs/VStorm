# PhpStorm feature map

Legend: **Full** = equivalent in daily use, **Partial** = works but weaker, **Gap** = no real equivalent.

| PhpStorm feature | VStorm | Provided by | Level |
|---|---|---|---|
| IntelliJ keymap | IDEA keybindings | `k--kato.intellij-idea-keybindings` + `keybindings.json` | Full |
| Darcula theme, JetBrains icons/font | Darcula, Material icons, JetBrains Mono | theme extensions, font package | Full |
| PHP code completion, navigation, find usages | Intelephense | `bmewburn.vscode-intelephense-client` | Full (rename/implementations need Intelephense premium) |
| Code inspections | PHPStan + PHPCS | `phpstan-vscode`, `php-sniffer` | Partial: fewer inspections, no quick-fix breadth |
| Refactoring (extract, move, change signature) | Basic extract/rename | Intelephense, keybindings | Partial |
| Formatter | PSR-12 via Intelephense / PHP-CS-Fixer / Pint | settings, global Composer tools | Full |
| Xdebug debugging | Listen, run-script, built-in server configs | `xdebug.php-debug`, `templates/launch.json` | Full |
| PHPUnit / Pest runner | Test explorer | `recca0120.vscode-phpunit`, Jest/Vitest for JS | Partial |
| Laravel | Blade, snippets, official extension | `laravel.vscode-laravel`, Blade extensions | Partial (no Laravel Idea-level model/route awareness) |
| Symfony | Twig, Symfony support | `whatwedo.twig`, `symfony-vscode` | Partial |
| Drupal | PHP file associations, YAML, snippets, drupal/coder | settings, `vstorm-cms.code-snippets` | Partial |
| WordPress | Hook completion, snippets, WPCS | `wordpress-hooks`, snippets, wp-coding-standards | Partial |
| Joomla | PHP associations, snippets | `vstorm-cms.code-snippets` | Partial (no dedicated extension) |
| JS/TS/Vue/React/Tailwind | Built-in TS server, ESLint, Prettier, Volar, Tailwind | extensions | Full |
| Debug JS in browser | Firefox/Chrome debug configs | built-in js-debug, `firefox-devtools.vscode-firefox-debug` | Full |
| Database tool window | SQL client | `cweijan.vscode-database-client2` | Partial |
| HTTP client (.http) | REST Client | `humao.rest-client` | Partial |
| Deployment / SFTP sync | Upload on save, remote explorer | `Natizyskunk.sftp` | Partial |
| FileZilla-style remote browsing | Mount SSH/SFTP hosts as folders | `kelvin.vscode-sshfs`, optional FileZilla GUI via `--with-filezilla` | Partial (no FTP-only/FTPS transfer queue in the editor; use FileZilla) |
| Git (log, blame, branches, merge) | GitLens, Git Graph | extensions | Partial (3-way merge UI is simpler) |
| Local History | Timeline + extension | `xyz.local-history` | Partial |
| TODO tool window, bookmarks | Todo Tree, Bookmarks | extensions | Full |
| Docker | Docker extension | `ms-azuretools.vscode-docker` | Partial |
| Search Everywhere (double Shift) | `Ctrl+P` / `Ctrl+Shift+P` | built-in | Partial (no double-Shift) |
| Database diagrams, UML, profiler, Code With Me, deep data-flow analysis | none | | Gap |

Closing the remaining gaps requires patching VSCodium itself (tier 3: tool-window strip, title-bar run configurations, Search Everywhere).
