# Ichthys.nvim

**Ichthys** (ikh-THOOS) - Greek for "fish," an ancient Christian symbol.

Personal, backend-leaning Neovim setup focused on Java, Python, TypeScript/JavaScript, C/C++, web, Lua, and shell work. Everything is lazy-loaded, built on Neovim 0.11+ native LSP APIs, and tuned for daily development rather than showcasing plugins.

## Intent
- Opinionated defaults: arrow keys disabled, `jj` to escape, space as leader.
- Fast startup with a small, purpose-picked plugin set.
- Strong tooling for Java/Spring, Python, JS/TS/React, C/C++, HTML/CSS, Lua, and Bash/Zsh.
- Local-first AI: Claude for explanations, Ollama-powered refactors.
- Built-in project dashboard and per-language task helpers.

## Highlights
- Gruvbox-material theme, smear-cursor, lualine with live LSP names, which-key, and dressed prompts.
- Navigation stack: Telescope (+fzf native), Oil as the file manager, Harpoon for quick marks, Aerial outline, Flash motion.
- LSP/formatting: clangd, typescript-tools, jdtls, basedpyright, ruff, html/css/emmet, lua_ls, bashls; conform with google-java-format, clang-format, prettier/eslint_d, ruff, stylua, shellcheck. Format on save enabled.
- Debugging & tests: DAP (codelldb, pwa-node, debugpy, jdtls bundles), neotest for Java, Jest, and pytest.
- Custom Dev Dashboard (`<leader>d`) showing git/ahead-behind, LSP clients, diagnostics, TODOs, Spring Boot hints, and system stats.
- AI: `:Explain`/`:Guide` via Claude; `:AIRefactor` via local Ollama with accept/reject/feedback workflow.
- Sessions via `persistence.nvim` with quick restore/skip keys.

## Requirements
- Neovim 0.11+, git.
- ripgrep; `make` (for telescope-fzf-native); `fd` optional for faster directory picker.
- Node.js + npm (ts/js LSP, jest adapter, `ts-node` for TypeScript run bindings).
- JDK 17+ (paths set for 21/17), Gradle/Maven for Java projects.
- Python 3.8+ for Python development; venv detection for debugger/LSP.
- gcc/g++ for C/C++.
- curl (Claude), shellcheck (shell formatting/checks), lazygit optional for `<leader>gg`.
- Optional: Ollama running locally (`ollama serve` + model), jq/tidy for nicer REST output.

## Installation
```bash
mv ~/.config/nvim ~/.config/nvim.backup
git clone https://github.com/JacobSmxth/Ichthys ~/.config/nvim
nvim   # lazy.nvim bootstraps and installs plugins
```

### Preferences
`~/.config/nvim/.preferences` (created on first write) controls toggles:
```
mouse=false
ollama_model=qwen3-coder:30b
```
Set `mouse=true` if you want it enabled.

### AI setup (optional)
- Claude: export `ANTHROPIC_API_KEY` (e.g., in `~/.zsh/.zshenv_private`) so `:Explain`/`:Guide` can call the API.
- Ollama refactor: install Ollama, pull a model (defaults to `qwen3-coder:30b`), run `ollama serve`, and select code + `<leader>ra`.

### Spring Boot tools (optional)
Place STS4 jars in `~/.local/share/nvim/spring-boot-tools/` to enhance jdtls for Spring projects (picked up automatically).

## Layout
```
~/.config/nvim/
|-- init.lua
|-- .preferences                 # mouse/ollama_model
|-- lua/
|   |-- core/                    # options, mappings, autocmds, appearance, prefs, project detection
|   |-- plugins/
|   |   |-- lazy_setup.lua       # loads specs
|   |   |-- specs/               # grouped plugin specs (ui, lsp, completion, treesitter, navigation, git, editor, tools, misc)
|   |   `-- configs/             # plugin configs (telescope, lualine, treesitter, toggleterm, etc.)
|   |-- claude/                  # Claude Explain/Guide
|   `-- airefactor/              # Ollama refactor (UI + API)
|-- plugin/                      # plugin entrypoints
`-- ftplugin/                    # language-specific commands (java, python, c/cpp, js/ts, html/css/scss, bash/zsh, lua)
```

## Keybindings
Leader: `Space`. Arrow keys are disabled. `jj` exits insert/terminal.

**Files & search**: `-` parent dir (Oil), `<leader>-` Oil float, `<leader>e` Oil sidebar, `<leader>/` buffer fuzzy find, `<leader>ff` files, `<leader>fg` live grep, `<leader>fG` regex grep (hidden), `<leader>fb` buffers, `<leader>fo` recent project files, `<leader>fD` pick directory -> Oil, `<leader>fm` man pages, `<leader><leader>` last buffer.

**Buffers/windows**: `<S-H>/<S-L>` prev/next buffer, `<leader>bd` delete buffer, `<C-h/j/k/l>` window nav, `<leader>wv/ws/wq/wo` split/close/only.

**LSP**: `gd/gD/gr/gI/gh`, `<leader>D` type def, `<leader>rn` rename, `<leader>ca` code action, `<C-k>` signature (normal/insert), `[d`/`]d` diagnostics, `<leader>ld` diagnostic float.

**Git**: `<leader>gg` lazygit, `[c`/`]c` prev/next hunk, `<leader>hs` stage hunk, `<leader>hr` reset hunk, `<leader>hp` preview, `<leader>hb` blame line.

**Diagnostics**: `<leader>xx` Trouble diagnostics, `<leader>xd` buffer diagnostics, `<leader>xq` quickfix list.

**Editing**: `<leader>i` fix indentation, `Alt+j/k` move lines, `<`/`>` keep selection, `gc` comments, `n/N` center search, visual `*` search, `<leader>c.` rerun last project command via `TermExec`, `<leader>yf/yF/yn/yl` yank path/full/name/file:line, `<leader>fM` view `:messages`.

**Terminal**: `<C-\\>` toggle terminal, `Esc` or `jj` to normal mode in terminal, same `Ctrl+h/j/k/l` window nav inside terminal.

**Debug**: `<leader>db/dc/di/do/dO/dr/dl/du/dt` (breakpoint, continue, step, repl, run last, UI toggle, terminate).

**Testing (neotest)**: `<leader>nr` nearest, `<leader>nf` file, `<leader>ns` summary, `<leader>no` output, `<leader>nd` debug test.

**Search/replace**: `<leader>sr` grug-far, `<leader>sw` search word, `<leader>sv` visual selection replace.

**REST**: `<leader>rr` run HTTP request, `<leader>rl` run last (in `.http` files).

**AI**: Visual `<leader>ce` Explain, `<leader>cq` prompt Claude, visual `<leader>ra` AI refactor. In refactor view: `a` accept, `r` reject, `f` send feedback to refine, `q` close.

**Sessions**: `<leader>qs` restore, `<leader>ql` last session, `<leader>qd` skip saving.

**Misc**: `<leader>a` Aerial outline, `<leader>z` Zen mode, `<leader>d` Dev Dashboard, `[q/ ]q/ [l/ ]l` quickfix/location nav.

### Filetype helpers
- **Java**: `<leader>cc` compile, `<leader>cr` compile+run, `<leader>cg` `bootRun` (prompt profile), `<leader>cR` restart bootRun, `<leader>cL` tail Spring log, `<leader>cb` build, `<leader>ct` tests, `<leader>cf` format (google-java-format), `<leader>cH` touch file for DevTools, `<leader>cp` open application props/yml, `<leader>cd` deps tree, `<leader>ci` organize imports, `<leader>to` toggle impl/test.
- **C/C++**: `<leader>cc` compile, `<leader>cr` compile+run, `<leader>cd` debug build, `<leader>cx` run built exe, `<leader>cm` make, `<leader>cv` valgrind, `<leader>cg` gdb, `<leader>cf` format.
- **TypeScript/JavaScript**: `<leader>cr` run (`ts-node`/node), `<leader>ct` npm test, `<leader>cb` build, `<leader>cs` start dev server, `<leader>ci` npm install, `<leader>cf` format.
- **Python**: `<leader>cr` run file, `<leader>ct` pytest all, `<leader>cT` pytest current file, `<leader>ci` pip install requirements, `<leader>cv` create venv, `<leader>cf` format (ruff).
- **HTML**: `<leader>cr` start `python3 -m http.server 8000`, `<leader>cf` format.
- **Bash/Zsh**: `<leader>cr` run, `<leader>cs` source, `<leader>cc` syntax check, `<leader>cf` format.

## Language support & tooling
- **Java**: jdtls, google-java-format (on save), debugger/test bundles (java-debug, java-test), Spring helpers, neotest-java.
- **Python**: basedpyright (type checking), ruff LSP (linting + formatting), debugpy DAP with venv detection, neotest-python (pytest).
- **TypeScript/JavaScript/React**: typescript-tools (inlay hints enabled), prettier + eslint_d via conform, pwa-node DAP, neotest-jest, run/build/dev server bindings.
- **C/C++**: clangd, clang-format, compile helpers, codelldb DAP, valgrind/gdb bindings.
- **HTML/CSS/SCSS**: html/css LSPs, emmet_ls, prettier formatting, quick live-server binding.
- **Lua**: lua-language-server + lazydev.nvim (Neovim API completions), stylua formatting.
- **Bash/Zsh**: bashls, shellcheck formatting/check.
- **General**: Format on save via conform. Inlay hints enabled globally. prettier for json/yaml/markdown.

## Plugins (curated)
- UI/navigation: gruvbox-material, smear-cursor, lualine, telescope(+fzf), oil, harpoon, dressing, which-key, fidget.
- Editing: mini.pairs/comment/surround/ai, flash, todo-comments, illuminate, ufo folds, persistence, zen-mode, aerial.
- LSP/tooling: mason + mason-tool-installer, nvim-lspconfig using `vim.lsp.config/enable`, typescript-tools, nvim-jdtls, lazydev, conform (format on save), treesitter suite.
- Git: gitsigns, lazygit.
- Tools: toggleterm, nvim-dap + ui + virtual text, refactoring.nvim, rest.nvim, neotest (java/jest/python), grug-far.
- AI: custom Claude Explain/Guide, custom Ollama refactor.
- Misc: Typr (`:Typr`), package-info.nvim for package.json hints.

## Dev Dashboard
`<leader>d` opens a split with branch/ahead-behind, last commit, git status, language versions (Java/Go/Node/Python), active LSP clients, Spring Boot detection (profile/port/status), diagnostics summary, TODO/FIXME hits via ripgrep, and basic system stats. Press `r` to refresh, `q` to close.

## Sessions
`persistence.nvim` saves on exit and can be skipped with `<leader>qd`. Restore with `<leader>qs` (current dir) or `<leader>ql` (last). Project detection runs on startup to load `.nvim.lua` if present.

"Commit thy works unto the Lord, and thy thoughts shall be established." - Proverbs 16:3 KJV
