{
  "workbench.colorTheme": "Darcula",
  "workbench.iconTheme": "material-icon-theme",
  "workbench.startupEditor": "none",
  "workbench.tree.indent": 14,
  "workbench.editor.highlightModifiedTabs": true,
  "workbench.editor.labelFormat": "short",
  "workbench.list.smoothScrolling": true,
  "window.commandCenter": true,
  "window.title": "${rootName}${separator}${activeEditorShort}",
  "telemetry.telemetryLevel": "off",
  "update.mode": "none",
  "extensions.autoUpdate": false,

  "editor.fontFamily": "'JetBrains Mono', 'DejaVu Sans Mono', monospace",
  "editor.fontSize": 13,
  "editor.fontLigatures": true,
  "editor.lineHeight": 1.5,
  "editor.rulers": [120],
  "editor.minimap.enabled": false,
  "editor.stickyScroll.enabled": true,
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": "active",
  "editor.inlayHints.enabled": "on",
  "editor.suggestSelection": "first",
  "editor.acceptSuggestionOnEnter": "on",
  "editor.snippetSuggestions": "top",
  "editor.formatOnSave": false,
  "editor.formatOnPaste": false,
  "editor.linkedEditing": true,
  "editor.renderWhitespace": "selection",
  "editor.smoothScrolling": true,
  "editor.cursorSmoothCaretAnimation": "on",
  "editor.wordWrap": "off",
  "editor.tabSize": 4,
  "editor.detectIndentation": true,
  "breadcrumbs.enabled": true,

  "files.autoSave": "onFocusChange",
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true
  },
  "files.watcherExclude": {
    "**/vendor/**": true,
    "**/node_modules/**": true,
    "**/var/cache/**": true,
    "**/storage/framework/**": true,
    "**/web/sites/*/files/**": true,
    "**/wp-content/cache/**": true
  },
  "search.exclude": {
    "**/vendor": true,
    "**/node_modules": true,
    "**/var/cache": true,
    "**/storage/framework": true,
    "**/web/sites/*/files": true,
    "**/wp-content/cache": true,
    "**/public/build": true
  },
  "files.associations": {
    "*.blade.php": "blade",
    "*.twig": "twig",
    "*.html.twig": "twig",
    "*.module": "php",
    "*.inc": "php",
    "*.install": "php",
    "*.theme": "php",
    "*.engine": "php",
    "*.profile": "php",
    "*.test": "php",
    "*.info.yml": "yaml",
    "*.libraries.yml": "yaml",
    "*.services.yml": "yaml",
    "*.routing.yml": "yaml",
    "*.http": "http",
    ".env.*": "dotenv"
  },

  "explorer.compactFolders": true,
  "explorer.autoReveal": true,
  "explorer.confirmDelete": true,
  "explorer.confirmDragAndDrop": false,
  "explorer.fileNesting.enabled": true,
  "explorer.fileNesting.patterns": {
    "*.php": "${capture}.test.php, ${capture}Test.php",
    "*.ts": "${capture}.js, ${capture}.d.ts, ${capture}.spec.ts, ${capture}.test.ts",
    "*.tsx": "${capture}.test.tsx, ${capture}.spec.tsx",
    "package.json": "package-lock.json, yarn.lock, pnpm-lock.yaml, .eslintrc*, eslint.config.*, .prettierrc*, tsconfig*.json, vite.config.*, webpack.config.*",
    "composer.json": "composer.lock, phpunit.xml*, phpstan.neon*, phpcs.xml*, .php-cs-fixer*, pint.json, psalm.xml"
  },

  "git.autofetch": true,
  "git.confirmSync": false,
  "git.enableSmartCommit": false,
  "git.openRepositoryInParentFolders": "always",
  "diffEditor.ignoreTrimWhitespace": false,
  "scm.defaultViewMode": "tree",

  "terminal.integrated.fontFamily": "'JetBrains Mono', monospace",
  "terminal.integrated.defaultLocation": "view",
  "terminal.integrated.env.linux": {
    "PATH": "@COMPOSER_BIN@:@HOME@/.local/bin:${env:PATH}"
  },

  "emmet.includeLanguages": {
    "blade": "html",
    "twig": "html",
    "php": "html"
  },
  "html.format.wrapLineLength": 120,

  "php.validate.enable": false,
  "php.suggest.basic": false,
  "intelephense.telemetry.enabled": false,
  "intelephense.format.braces": "psr12",
  "intelephense.environment.phpVersion": "8.4.0",
  "intelephense.files.maxSize": 5000000,
  "intelephense.files.associations": ["*.php", "*.phtml", "*.inc", "*.module", "*.install", "*.theme", "*.engine", "*.profile"],
  "phpSniffer.executablesFolder": "@COMPOSER_BIN@/",
  "phpSniffer.standard": "PSR12",
  "phpSniffer.autoDetect": true,
  "phpstan.binPath": "@COMPOSER_BIN@/phpstan",
  "php-cs-fixer.executablePath": "@COMPOSER_BIN@/php-cs-fixer",
  "php-cs-fixer.onsave": false,

  "[php]": {
    "editor.defaultFormatter": "bmewburn.vscode-intelephense-client",
    "editor.tabSize": 4
  },
  "[blade]": {
    "editor.defaultFormatter": "shufo.vscode-blade-formatter",
    "editor.tabSize": 4
  },
  "[twig]": {
    "editor.tabSize": 4
  },
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[vue]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.tabSize": 2
  },
  "[yaml]": {
    "editor.tabSize": 2
  },

  "eslint.validate": ["javascript", "javascriptreact", "typescript", "typescriptreact", "vue"],
  "javascript.updateImportsOnFileMove.enabled": "always",
  "typescript.updateImportsOnFileMove.enabled": "always",
  "typescript.preferences.importModuleSpecifier": "relative",
  "npm.packageManager": "npm",

  "sftp.printDebugLog": false,
  "todo-tree.general.tags": ["TODO", "FIXME", "HACK", "XXX"],
  "todo-tree.tree.showScanModeButton": false,
  "errorLens.enabledDiagnosticLevels": ["error", "warning"],
  "cSpell.enabled": false
}
