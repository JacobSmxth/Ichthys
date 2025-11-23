# Ichthys.nvim

**Ichthys** (ikh-THOOS) - Greek for "fish", an ancient Christian symbol.

A modern, performance-focused Neovim configuration built to glorify the Lord through excellent software craftsmanship.

## What Makes This Different

This is not a general-purpose Neovim distribution. It's a **personalized, production-ready development environment** specifically optimized for:

- **Backend & Systems Development**: Java, C/C++, C#, Go, Python
- **Web Development**: TypeScript/JavaScript, React, HTML/CSS/SCSS
- **DevOps & Scripting**: Bash/Zsh, Lua
- **Maximum Performance**: 69ms startup with 50+ plugins through aggressive lazy loading
- **Modern APIs**: Uses Neovim 0.11+ native LSP features that most configs haven't adopted yet
- **Complete Debugging**: Full DAP support for all languages (not just demos)
- **Faith-Centered**: Built with intentionality to honor God through excellence

## Features

- **Bleeding-edge Neovim 0.11+** with new native LSP APIs (`vim.lsp.config`, `vim.lsp.enable`)
- **Lightning-fast startup** (69ms) through strategic lazy loading
- **9 language environments**: Java, C/C++, C#, Go, Python, TypeScript/JavaScript, HTML/CSS/SCSS, Bash/Zsh, Lua
- **Production-ready debugging** with DAP adapters for every language
- **AI-powered completion** via Codeium
- **Git workflow** integration with LazyGit + Gitsigns
- **Smart project sessions** with auto-save/restore and git branch awareness
- **6 beautiful color themes** with easy switching (gruvbox-material, catppuccin, kanagawa, tokyonight, etc.)
- **Mouse toggle system** - enable/disable via config file

---

## Keybindings

**Leader Key**: `Space`

### Core Philosophy
- **No arrow keys** - Disabled to enforce hjkl navigation
- **jj to escape** - Quick escape from insert/terminal mode
- **Space-based leader** - Ergonomic and discoverable with which-key

### Navigation

| Keybind | Description |
|---------|-------------|
| `Shift+H` / `Shift+L` | Previous/Next buffer |
| `<leader>bd` | Delete buffer with fzf picker |
| `Ctrl+h/j/k/l` | Navigate windows |
| `<leader><leader>` | Toggle last two buffers |
| `-` | Open parent directory (Oil) |
| `<leader>-` | Open Oil (floating) |
| `<leader>e` | Toggle file tree (nvim-tree) |
| `<leader>a` | Toggle code outline (Aerial) |

### Search & Find (Telescope)

| Keybind | Description |
|---------|-------------|
| `/` | Native search (regex) |
| `<leader>/` | Fuzzy find in buffer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Find buffers |
| `<leader>fs` | Find sessions |
| `<leader>fd` | Delete session |
| `<leader>fm` | Find man pages |

### Harpoon (Quick File Bookmarks)

| Keybind | Description |
|---------|-------------|
| `<leader>ha` | Add file |
| `<leader>hh` | Toggle menu |
| `<leader>h1-4` | Jump to file 1-4 |
| `<leader>hn` / `<leader>hp` | Next/Previous |

### LSP (Language Server)

| Keybind | Description |
|---------|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gh` | Hover documentation |
| `K` | Man page lookup (native) |
| `Ctrl+k` | Signature help (normal/insert) |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cl` | Run code lens |
| `<leader>D` | Type definition |
| `[d` / `]d` | Previous/Next diagnostic |

### Git

| Keybind | Description |
|---------|-------------|
| `<leader>gg` | Open LazyGit |

### Editing

| Keybind | Description |
|---------|-------------|
| `jj` | Escape (insert/terminal mode) |
| `<leader>i` | Fix indentation (entire file) |
| `Alt+j` / `Alt+k` | Move line(s) up/down |
| `<` / `>` | Indent/outdent (stays in visual) |
| `gc` | Comment (motion/visual) |
| `n` / `N` | Next/prev search (centered with zzzv) |

### "Go Inner" (Custom Visual Selection) **UNIQUE**

**This is a custom operator** that selects inside a text object and jumps to the end. Perfect for rapid editing workflows.

Select inside and jump to end:

| Keybind | Selection |
|---------|-----------|
| `git` | Tag |
| `gi"` `gi'` `gi\`` | Quotes |
| `gi(` `gi)` `gib` | Parentheses |
| `gi{` `gi}` `giB` | Braces |
| `gi[` `gi]` | Brackets |
| `gi<` `gi>` | Angle brackets |

**Example**: `gi{` in a function will select all content inside braces and place cursor at the end.

### AI Completion (Codeium)

| Keybind | Description |
|---------|-------------|
| `Tab` | Accept suggestion |
| `Alt+h` / `Alt+l` | Cycle suggestions (prev/next) |
| `Ctrl+x` | Clear suggestion |
| `<leader>ot` | Toggle Codeium on/off |

### Claude AI Assistant (Built-in)

| Keybind | Description |
|---------|-------------|
| `<leader>ce` | Explain selected code (visual mode) |
| `<leader>cq` | Ask Claude a question (opens prompt) |

**Commands (alternative):**
- `:Explain` - Explain selected code (visual mode)
- `:Guide <query>` - Get AI guidance on any topic

### Windows

| Keybind | Description |
|---------|-------------|
| `<leader>wv` | Vertical split |
| `<leader>ws` | Horizontal split |
| `<leader>wq` | Close window |
| `<leader>wo` | Close other windows |

### Hop (Motion)

| Keybind | Description |
|---------|-------------|
| `m` | Hop to word |
| `M` | Hop to line |

### REST Client (Kulala)

| Keybind | Description |
|---------|-------------|
| `<leader>kr` | Run request (.http files) |
| `<leader>kt` | Toggle headers/body |
| `<leader>kc` | Copy as cURL |

### Debugging (DAP)

| Keybind | Description |
|---------|-------------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>du` | Toggle debug UI |
| `<leader>dt` | Terminate |

### Diagnostics (Trouble)

| Keybind | Description |
|---------|-------------|
| `<leader>xx` | Toggle diagnostics |
| `<leader>xd` | Buffer diagnostics |
| `<leader>xq` | Quickfix list |

### Other

| Keybind | Description |
|---------|-------------|
| `<leader>u` | Undo tree |
| `Ctrl+\` | Toggle terminal |
| `Esc` | Clear search highlight |

---

## Plugins

### Philosophy
Every plugin is **lazy-loaded** and serves a specific purpose. No bloat, no unused features.

### UI & Navigation
- **dashboard-nvim** - Beautiful startup screen with verse
- **nvim-tree.lua** - Traditional file tree explorer
- **oil.nvim** - Edit filesystem like a buffer (modern alternative)
- **telescope.nvim** - Fuzzy finder for everything
- **harpoon** - ThePrimeagen's quick file bookmarks (harpoon2)
- **aerial.nvim** - LSP-powered code outline sidebar
- **lualine.nvim** - Fast, customizable statusline
- **which-key.nvim** - Popup showing keybind options
- **indent-blankline.nvim** - Subtle indent guides
- **nvim-web-devicons** - File type icons

### LSP & Completion
- **mason.nvim** - Package manager for LSP servers, formatters, linters, debuggers
- **nvim-lspconfig** - Official LSP configurations (using 0.11+ APIs)
- **nvim-jdtls** - Enhanced Java support with Eclipse JDTLS
- **typescript-tools.nvim** - Faster TypeScript with inlay hints
- **nvim-cmp** - Completion engine with intelligent sources
- **LuaSnip** - Snippet engine with VSCode snippet support
- **codeium.vim** - AI-powered code completion (free GitHub Copilot alternative)

### Code Intelligence
- **nvim-treesitter** - Syntax highlighting via Tree-sitter parsers
- **nvim-treesitter-context** - "Sticky scroll" showing current function/class (6 lines)
- **nvim-ts-autotag** - Auto-close HTML/JSX tags
- **conform.nvim** - Modern formatter with multiple formatters per filetype

### Git Integration
- **gitsigns.nvim** - Git changes in sign column with inline blame
- **lazygit.nvim** - Full-featured git TUI inside Neovim

### Editing Enhancements
- **nvim-autopairs** - Auto-close brackets/quotes with smart rules
- **Comment.nvim** - Toggle comments with `gc`
- **nvim-surround** - Add/change/delete surrounding pairs
- **hop.nvim** - EasyMotion-style navigation

### Debugging (DAP)
All languages have full debugging support:
- **nvim-dap** - Debug Adapter Protocol client
- **nvim-dap-ui** - Beautiful debug UI with variables, watches, stack traces
- **nvim-dap-go** - Go debugging (Delve)
- **nvim-dap-python** - Python debugging (debugpy)
- **nvim-dap-virtual-text** - Show variable values inline while debugging

Language-specific adapters auto-configured:
- Java: java-debug-adapter
- C/C++: codelldb
- C#: netcoredbg
- JavaScript/TypeScript: js-debug-adapter

### Session & Workflow
- **auto-session** - Auto-save/restore workspace per git branch
- **telescope-undo.nvim** - Visual undo tree with Telescope
- **trouble.nvim** - Beautiful diagnostics/quickfix list
- **toggleterm.nvim** - Floating/split terminals
- **kulala.nvim** - REST client for .http files
- **render-markdown.nvim** - Live markdown preview
- **todo-comments.nvim** - Highlight TODO/FIX/NOTE/WARN
- **fidget.nvim** - LSP progress notifications

### AI Assistant
- **claude** - Built-in Claude AI plugin for code explanations and guidance
  - `:Explain` - Explain highlighted code in visual mode
  - `:Guide <query>` - Get AI help on any development topic
  - Async API calls (non-blocking)
  - Markdown responses with syntax highlighting
  - Requires `ANTHROPIC_API_KEY` environment variable

---

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua        # Vim options
│   │   ├── mappings.lua       # Keybindings
│   │   ├── autocmds.lua       # Auto-commands
│   │   └── appearance.lua     # Theme & font configuration
│   ├── claude/                # Claude AI plugin
│   │   ├── init.lua          # Main plugin logic
│   │   ├── api.lua           # Claude API client
│   │   └── ui.lua            # Response display
│   └── plugins/
│       ├── lazy_setup.lua     # Plugin definitions
│       └── configs/           # Plugin configurations
│           ├── lsp.lua
│           ├── telescope.lua
│           ├── cmp.lua
│           └── ...
├── plugin/
│   └── claude.lua             # Auto-loads Claude plugin
└── ftplugin/                   # Filetype-specific configs
    ├── java.lua
    ├── python.lua
    ├── go.lua
    └── ...
```

---

## Custom Settings & Personalization

### Claude AI Setup **NEW**

The built-in Claude plugin provides code explanations and development guidance.

**Setup (one-time):**
```bash
# Add to your ~/.bashrc or ~/.zshrc
export ANTHROPIC_API_KEY="your-api-key-here"
```

**Usage:**
1. **Explain Code**:
   - Highlight code with `v` / `V` / `Ctrl-v`
   - Type `:Explain` and press Enter
   - Get intelligent explanation in markdown split

2. **Get Guidance**:
   - Type `:Guide <your question>`
   - Examples:
     - `:Guide how to use vim motions`
     - `:Guide build a shell in C`
     - `:Guide explain async/await in JavaScript`

**Features:**
- Non-blocking async API calls
- Markdown-formatted responses
- Filetype-aware code explanations
- Press `q` to close response window

### Theme Configuration **UNIQUE**
Easily customize your color theme with the appearance configuration system:

**Available Themes:**
- gruvbox-material (default)
- gruvbox
- catppuccin
- nightfox
- kanagawa
- tokyonight

**Commands:**
```vim
" View or change theme
:Theme                     " Show available themes
:Theme gruvbox-material    " Switch to gruvbox-material
:Theme catppuccin          " Switch to catppuccin
```

To change default permanently, edit `lua/core/appearance.lua`:
```lua
M.selected_theme = "kanagawa"    -- Change default theme
```

### Mouse Toggle System **UNIQUE**
Simple file-based mouse control for flexibility:
```bash
# Check current setting
cat ~/.config/nvim/.mouse

# Enable mouse
echo "true" > ~/.config/nvim/.mouse

# Disable mouse (default)
echo "false" > ~/.config/nvim/.mouse
```
Then restart Neovim. Any value other than `true` = disabled.

### General Settings
- **Line numbers**: Relative + absolute hybrid
- **Indentation**: 2 spaces default (language-specific in ftplugin)
- **Clipboard**: System clipboard integrated (`unnamedplus`)
- **Persistent undo**: 1000 levels, stored in cache directory
- **No swap/backup files** - rely on git + auto-session
- **Cursorline**: Enabled with VSCode Dark+ highlight
- **Scroll context**: 8 lines top/bottom

### Search Behavior
- Smart case-insensitive (case-sensitive if uppercase used)
- Incremental search with highlight
- `Esc` to clear highlights
- `n/N` centers screen with `zzzv`

### Splits & Windows
- Vertical splits open right
- Horizontal splits open below
- Easy navigation with `Ctrl+hjkl`

### Performance Optimizations
- Disabled runtime plugins: gzip, tarPlugin, tohtml, tutor, zipPlugin
- Update time: 250ms (LSP responsiveness)
- Timeout: 300ms (which-key popup)
- Lazy loading for all plugins except core

---

## Auto-Commands

- **Trim trailing whitespace** on save
- **Highlight yanked text** (200ms flash)
- **Auto-format Java** files on save
- **Restore cursor position** when reopening files
- **Disable auto-comment** on new lines
- **Smart indent settings** per filetype

---

## Language Support

**Complete development environments** for all languages I actually use. Everything else removed for performance.

### Java
- **LSP**: Eclipse JDTLS (full enterprise Java support)
- **Formatter**: google-java-format
- **Debugger**: java-debug-adapter + java-test
- **Features**: Auto-format on save, organize imports, code lens

### C/C++
- **LSP**: clangd
- **Formatter**: clang-format
- **Debugger**: codelldb
- **Features**: Compile commands support, header switching

### C#
- **LSP**: OmniSharp
- **Formatter**: csharpier
- **Debugger**: netcoredbg
- **Features**: .NET Core/Framework support, solution/project detection

### Go
- **LSP**: gopls
- **Formatters**: goimports → gofumpt (chain)
- **Debugger**: delve (via nvim-dap-go)
- **Features**: Staticcheck, gofumpt on save, unused params detection

### Python
- **LSP**: pyright
- **Formatters**: isort → black (chain)
- **Linter**: ruff (fast Rust-based linter)
- **Debugger**: debugpy
- **Features**: Type checking, auto-import sorting

### TypeScript/JavaScript/React
- **LSP**: typescript-tools (enhanced tsserver)
- **Formatters**: prettier → eslint_d (chain)
- **Debugger**: js-debug-adapter (vscode-js-debug)
- **Features**: Inlay hints, auto-import, JSX/TSX support

### HTML/CSS/SCSS
- **LSP**: html-lsp, css-lsp, emmet-ls
- **Formatter**: prettier
- **Features**: Emmet expansion, auto-close tags

### Bash/Zsh
- **LSP**: bash-language-server
- **Linter**: shellcheck
- **Features**: Shell script validation, completion

### Lua
- **LSP**: lua-language-server (Neovim-configured)
- **Formatter**: stylua
- **Linter**: luacheck
- **Features**: Neovim API completion, `vim` global recognized

---

## Session Management

Sessions automatically save on exit and restore on startup.

### How It Works
- **Auto-save**: Saves your workspace (buffers, splits, positions) when you exit nvim
- **Auto-restore**: Restores your exact layout when you reopen nvim in the same directory
- **Per git branch**: Each git branch gets its own session (switch branches = different session)
- **Excluded dirs**: Sessions are NOT saved in `~/`, `~/Downloads`, or `/`

### Keybindings & Commands
- `<leader>fs` - Find/restore sessions (Telescope fuzzy finder)
- `<leader>fd` - Delete session (Telescope fuzzy finder with confirmation)
- `:AutoSession save` - Manual save current session
- `:AutoSession delete` - Delete current session

### What Gets Saved
Buffers, splits, window positions, folds, tabs, terminal windows, and local options.

---

## Performance

**Startup Time**: 69ms (measured with `time nvim +q`)

- Bare Neovim: 20-30ms
- This config: 69ms (50+ plugins, lazy loaded)
- Most configs: 100-300ms
- Heavy configs: 500ms+

### Benchmark Your Config

```bash
# Quick timing
time nvim +q

# Detailed startup log
nvim --startuptime startup.log +q && cat startup.log

# Plugin profiling (inside nvim)
:Lazy profile
```

---

## Requirements

- **Neovim** 0.11+
- **Git**
- **Ripgrep** (for telescope live_grep)
- **Make** (for telescope-fzf-native)
- **Node.js** (for some LSP servers)
- **curl** (for Claude AI plugin)
- **LazyGit** (optional, for `<leader>gg`)
- **Nerd Font** (for icons)

---

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone https://github.com/JacobSmxth/Ichthys ~/.config/nvim

# Set up Claude AI (optional but recommended)
export ANTHROPIC_API_KEY="your-api-key-here"
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.bashrc  # or ~/.zshrc

# Open nvim - plugins auto-install
nvim
```

---

## Why This Config Exists

### The Problem with Most Configs
- **Too general**: Try to support every language under the sun
- **Performance suffers**: 300-500ms startups are common
- **Outdated patterns**: Still using deprecated APIs
- **Demo-ware**: LSP/DAP configured but not production-ready

### My Approach
1. **Personalized**: Only languages I use = faster everything
2. **Performance-obsessed**: 69ms startup through strategic lazy loading
3. **Modern**: Neovim 0.11+ APIs that most configs haven't adopted
4. **Production-ready**: Every language has LSP + formatter + linter + debugger
5. **Faith-centered**: Built with intentionality to glorify God

### Design Principles
- **No bloat**: If I don't use it, it's not here
- **Custom keybinds**: "Go inner" operator, centered search, etc.
- **Smart defaults**: Mouse toggle, jj escape, space leader
- **Maintainable**: Clean structure, well-commented, modular

"Commit thy works unto the Lord, and thy thoughts shall be established." - Proverbs 16:3 KJV

---

## Who This Is For

**This config is for you if:**
- You work with Java, C/C++, C#, Go, Python, TypeScript/JavaScript
- You want a **fast**, opinionated setup
- You value performance over trying every new plugin
- You want debugger support, not just LSP
- You appreciate faith-centered development

**This config is NOT for you if:**
- You need Rust, Zig, Haskell, or other languages not listed
- You want a minimal "learn Neovim" setup (try kickstart.nvim)
- You prefer distributions like LazyVim/NvChad (this is personalized, not general)

---

## Fork It, Make It Yours

This is my **personal** config. I encourage you to:
1. Fork it
2. Remove languages you don't use
3. Add your own keybinds
4. Adjust the theme
5. Make it yours

The `.mouse` file system and "go inner" operators are examples of how to personalize beyond just changing options.

---

## Everything Different from Vanilla Neovim

This is a comprehensive list of **every change** from stock Neovim. Perfect for understanding what you're getting.

### Keybindings Changed/Added

#### Disabled Keys (Training Wheels Off)
- **Arrow keys** - Disabled in normal, insert, and visual modes (forces hjkl)
- **Mouse** - Disabled by default (toggle via `.mouse` file)

#### Custom Escape & Navigation
- `jj` → Escape (insert and terminal modes)
- `Shift+H` / `Shift+L` → Previous/Next buffer
- `Ctrl+h/j/k/l` → Navigate between windows
- `<leader><leader>` (Space+Space) → Toggle between last two buffers
- `-` → Open parent directory in Oil.nvim
- `<leader>-` → Open Oil in floating window
- `Esc` → Clear search highlights

#### Search Improvements
- `n` / `N` → Next/previous search result (centered with `zzzv`)

#### Line Movement
- `Alt+j` / `Alt+k` → Move lines up/down (visual mode too)

#### Visual Mode Enhancements
- `<` / `>` → Indent/outdent and stay in visual mode

#### Custom "Go Inner" Operators **UNIQUE TO THIS CONFIG**
Select inside text object and jump to end (custom implementation):
- `git` / `gi"` / `gi'` / `gi\`` / `gi(` / `gi)` / `gib` / `gi{` / `gi}` / `giB` / `gi[` / `gi]` / `gi<` / `gi>`

#### Leader Key Mappings (Space as Leader)
**File Explorer:**
- `<leader>e` → Toggle nvim-tree
- `<leader>a` → Toggle Aerial code outline

**Telescope (Fuzzy Finding):**
- `<leader>/` → Fuzzy find in current buffer
- `<leader>ff` → Find files
- `<leader>fg` → Live grep (search in files)
- `<leader>fb` → Find buffers
- `<leader>fs` → Find/restore sessions
- `<leader>fd` → Delete session (with confirmation)
- `<leader>fm` → Find man pages (custom Telescope picker)

**Harpoon (Quick Bookmarks):**
- `<leader>ha` → Add file to harpoon
- `<leader>hh` → Toggle harpoon menu
- `<leader>h1-4` → Jump to harpoon files 1-4
- `<leader>hn/hp` → Next/previous harpoon file

**LSP (Language Server):**
- `gd` → Go to definition
- `gD` → Go to declaration
- `gr` → Go to references
- `gI` → Go to implementation
- `gh` → Hover documentation
- `Ctrl+k` → Signature help (normal and insert mode)
- `<leader>D` → Type definition
- `<leader>rn` → Rename symbol
- `<leader>ca` → Code action
- `<leader>cl` → Run code lens
- `[d` / `]d` → Previous/next diagnostic

**Editing:**
- `<leader>i` → Fix indentation for entire file
- `gc` → Comment/uncomment (Comment.nvim)
- `m` → Hop to word (EasyMotion-style)
- `M` → Hop to line

**Windows:**
- `<leader>wv` → Vertical split
- `<leader>ws` → Horizontal split
- `<leader>wq` → Close window
- `<leader>wo` → Close other windows

**Git:**
- `<leader>gg` → Open LazyGit

**Debugging (DAP):**
- `<leader>db` → Toggle breakpoint
- `<leader>dc` → Continue
- `<leader>di` → Step into
- `<leader>do` → Step over
- `<leader>dO` → Step out
- `<leader>dr` → Toggle REPL
- `<leader>dl` → Run last
- `<leader>dt` → Terminate
- `<leader>du` → Toggle debug UI

**Diagnostics:**
- `<leader>xx` → Toggle diagnostics (Trouble)
- `<leader>xd` → Buffer diagnostics
- `<leader>xq` → Quickfix list

**REST Client (Kulala):**
- `<leader>kr` → Run HTTP request (.http files)
- `<leader>kt` → Toggle headers/body
- `<leader>kc` → Copy as cURL

**Other:**
- `<leader>u` → Undo tree (Telescope)
- `<leader>bd` → Delete buffer
- `Ctrl+\` → Toggle terminal
- `<leader>ot` → Toggle Codeium AI

**AI Completion (Codeium):**
- `Tab` → Accept suggestion
- `Alt+h` / `Alt+l` → Cycle suggestions
- `Ctrl+x` → Clear suggestion

### Editor Behavior Changes

#### Line Numbers
- **Relative + absolute hybrid** - Shows current line number + relative distances

#### Indentation
- **2 spaces** by default (overridden per-language in ftplugin)
- **Smart indent** enabled
- **Expand tab** - always uses spaces, never tabs

#### Cursor & Scrolling
- **Cursorline highlight** - Current line highlighted
- **Scroll offset 8** - Keeps 8 lines above/below cursor
- **Block cursor** in all modes

#### Clipboard
- **System clipboard integration** - Yank/paste works with OS clipboard

#### Undo System
- **Persistent undo** - Undo history saved between sessions
- **1000 undo levels**
- **Undo directory** - `~/.local/share/nvim/undo/`

#### Files & Backups
- **No swap files**
- **No backup files**
- **No writebackup**
- **Hidden buffers** - Can switch buffers without saving

#### Search
- **Smart case** - Case-insensitive unless uppercase used
- **Incremental search**
- **Highlight search results**

#### Splits
- **Split right** - Vertical splits open to the right
- **Split below** - Horizontal splits open below

#### UI
- **No mode indicator** (shown in statusline instead)
- **Sign column always visible**
- **Popup menu height 10**
- **No line wrapping** by default
- **True color support**
- **Conceallevel 0** - Show everything (no hidden syntax)

#### Performance
- **Update time 250ms** - Faster LSP/CursorHold
- **Timeout 300ms** - Which-key popup delay
- **Disabled runtime plugins**: gzip, tarPlugin, tohtml, tutor, zipPlugin

#### Mouse
- **Disabled by default** - Toggle via `~/.config/nvim/.mouse` file

### Auto-Commands

- **Trim trailing whitespace** on save
- **Highlight yanked text** for 200ms
- **Auto-format Java files** on save
- **Restore cursor position** when reopening files
- **Disable auto-comment** on new lines
- **LSP inlay hints** auto-enabled when supported
- **Code lens refresh** on BufEnter, CursorHold, InsertLeave

### Theme & Colors

- **6 beautiful color themes**: gruvbox-material (default), gruvbox, catppuccin, nightfox, kanagawa, tokyonight
- **Easy theme switching** with `:Theme` command and tab completion
- **Centralized theme config** in `lua/core/appearance.lua`

### Language Support (Everything Auto-Installed)

#### Java
- Eclipse JDTLS, google-java-format, java-debug-adapter, java-test
- Auto-format on save, organize imports

#### C/C++
- clangd, clang-format, codelldb

#### C#
- OmniSharp, csharpier, netcoredbg

#### Go
- gopls, goimports, gofumpt, delve, nvim-dap-go

#### Python
- pyright, black, isort, ruff, debugpy, nvim-dap-python

#### TypeScript/JavaScript
- typescript-tools, prettier, eslint_d, js-debug-adapter

#### HTML/CSS/SCSS
- html-lsp, css-lsp, emmet-ls, prettier

#### Bash/Zsh
- bash-language-server, shellcheck

#### Lua
- lua-language-server (configured for Neovim), stylua, luacheck

### Plugins Added (50+)

See "Plugins" section above for full list. Every plugin is **lazy-loaded** for performance.

### Session Management

- **Auto-save sessions** on exit (per directory)
- **Auto-restore sessions** on startup
- **Git branch awareness** - Different session per branch
- **Excluded directories**: `~/`, `~/Downloads`, `/`

### Startup Dashboard

- **Custom ASCII art** header with "ICHTHYS"
- **Bible verse footer**: Proverbs 16:3 KJV
- **Quick actions**: New file, recent files, find file, grep, settings, quit

### File Structure

```
~/.config/nvim/
├── init.lua                  # Entry point
├── .mouse                    # Mouse toggle (true/false)
├── lua/
│   ├── core/
│   │   ├── options.lua      # All vim options
│   │   ├── mappings.lua     # All keybindings
│   │   ├── autocmds.lua     # Auto-commands
│   │   └── appearance.lua   # Theme & font configuration
│   └── plugins/
│       ├── lazy_setup.lua   # All plugin definitions
│       └── configs/         # Plugin configurations
│           ├── lsp.lua
│           ├── cmp.lua
│           ├── telescope.lua
│           ├── codeium.lua
│           └── ...
└── ftplugin/                 # Language-specific configs
    ├── java.lua
    ├── python.lua
    ├── go.lua
    └── ...
```

### What's NOT Changed

- **Vim motions** - All standard hjkl, w/b/e, f/t, etc. work normally
- **Ex commands** - All `:` commands work as expected
- **Macros** - `q` to record, `@` to play
- **Marks** - `m` and `` ` `` work (except `m` remapped to Hop in normal mode)
- **Registers** - All registers work normally
- **Visual block mode** - `Ctrl+v` unchanged

### Summary Stats

- **50+ plugins** installed
- **9 language environments** fully configured
- **100+ custom keybindings**
- **69ms startup time**
- **6 lines sticky scroll** (treesitter-context)
- **0 swap files** ever created
- **∞ undo history** (persisted across sessions)

This config turns Neovim into a **full IDE** while keeping the modal editing and performance that makes Neovim special.
