# Ichthys.nvim

**Ichthys** (ikh-THOOS) - Greek for "fish", an ancient Christian symbol.

A modern, performance-focused Neovim configuration built to glorify the Lord through excellent software craftsmanship.

## What Makes This Different

This is not a general-purpose Neovim distribution. It's a **personalized, production-ready development environment** specifically optimized for:

- **Backend & Systems Development**: Java/Spring Boot, C/C++, Go, Python
- **Web Development**: TypeScript/JavaScript, React, HTML/CSS/SCSS
- **DevOps & Scripting**: Bash/Zsh, Lua
- **Maximum Performance**: 67ms startup through aggressive lazy loading
- **AI-Powered Refactoring**: Local Ollama integration for intelligent code improvements
- **Modern APIs**: Uses Neovim 0.11+ native LSP features
- **Complete Debugging**: Full DAP support for all languages
- **Database Development**: Integrated SQL client with completion
- **Faith-Centered**: Built with intentionality to honor God

## Features

- **Bleeding-edge Neovim 0.11+** with native LSP APIs (`vim.lsp.config`, `vim.lsp.enable`)
- **Lightning-fast startup** (67ms average) through strategic lazy loading
- **9 language environments**: Java, C/C++, C#, Go, Python, TypeScript/JavaScript, HTML/CSS/SCSS, Bash/Zsh, Lua
- **Production-ready debugging** with DAP adapters for every language
- **AI-powered refactoring**: Ollama + Claude explanations
- **Database client**: vim-dadbod with UI and completion
- **REST client**: .http file support for API testing
- **Unified test runner**: neotest with adapters for all languages
- **Git workflow** integration with LazyGit + Gitsigns
- **Smart project sessions** with auto-save/restore and git branch awareness
- **Project-aware dashboard** with LSP status, Spring Boot detection, and more

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
| `<leader>bd` | Delete buffer |
| `Ctrl+h/j/k/l` | Navigate windows |
| `<leader><leader>` | Toggle last two buffers |
| `-` | Open parent directory (Oil) |
| `<leader>-` | Open Oil (floating) |
| `<leader>e` | Toggle Oil sidebar |
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
| `<C-k>` | Signature help (normal/insert) |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>D` | Type definition |
| `[d` / `]d` | Previous/Next diagnostic |
| `<leader>ld` | Show diagnostic float |

### Git

| Keybind | Description |
|---------|-------------|
| `<leader>gg` | Open LazyGit |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line |

### Editing

| Keybind | Description |
|---------|-------------|
| `jj` | Escape (insert/terminal mode) |
| `<leader>i` | Fix indentation (entire file) |
| `Alt+j` / `Alt+k` | Move line(s) up/down |
| `<` / `>` | Indent/outdent (stays in visual) |
| `gc` | Comment (motion/visual) |
| `n` / `N` | Next/prev search (centered) |

### "Go Inner" (Custom Visual Selection)

Select inside a text object and jump to the end:

| Keybind | Selection |
|---------|-----------|
| `git` | Tag |
| `gi"` `gi'` `gi\`` | Quotes |
| `gi(` `gi)` `gib` | Parentheses |
| `gi{` `gi}` `giB` | Braces |
| `gi[` `gi]` | Brackets |
| `gi<` `gi>` | Angle brackets |

### Completion (nvim-cmp)

| Keybind | Description |
|---------|-------------|
| `<Tab>` | Next completion item |
| `<S-Tab>` | Previous completion item |
| `<CR>` | Confirm selection |
| `<C-j>` / `<C-k>` | Next/previous item |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Close completion menu |

### Claude AI Assistant

| Keybind | Description |
|---------|-------------|
| `<leader>ce` | Explain selected code (visual mode) |
| `<leader>cq` | Ask Claude a question |

### AI Refactoring (Ollama)

| Keybind | Description |
|---------|-------------|
| `<leader>ra` | AI-powered refactoring (visual mode) |

**Actions (when refactor UI is open):**
- `a` - Accept refactoring
- `r` - Reject refactoring
- `q` - Close without changes

### Database (vim-dadbod)

| Keybind | Description |
|---------|-------------|
| `<leader>Du` | Toggle Database UI |
| `<leader>Df` | Find DB buffer |

### REST Client (rest.nvim)

| Keybind | Description |
|---------|-------------|
| `<leader>rr` | Run HTTP request (.http files) |
| `<leader>rl` | Run last request |

### Test Runner (neotest)

| Keybind | Description |
|---------|-------------|
| `<leader>nr` | Run nearest test |
| `<leader>nf` | Run file tests |
| `<leader>ns` | Toggle test summary |
| `<leader>no` | Show test output |
| `<leader>nd` | Debug nearest test (DAP) |

### Search & Replace (grug-far)

| Keybind | Description |
|---------|-------------|
| `<leader>sr` | Open find and replace |
| `<leader>sw` | Find word under cursor |
| Visual `<leader>sr` | Find selection |

### Windows

| Keybind | Description |
|---------|-------------|
| `<leader>wv` | Vertical split |
| `<leader>ws` | Horizontal split |
| `<leader>wq` | Close window |
| `<leader>wo` | Close other windows |

### Flash (Motion)

| Keybind | Description |
|---------|-------------|
| `m` | Flash jump |
| `M` | Flash Treesitter (syntax-aware) |

### Dev Dashboard

| Keybind | Description |
|---------|-------------|
| `<leader>d` | Open Dev Dashboard |

**Dashboard shows:**
- Git branch, ahead/behind, last commit
- Project info with language versions
- Active LSP servers
- Spring Boot status (if detected)
- Diagnostics summary
- TODO/FIXME comments
- System info

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

### Task Runner (Overseer)

| Keybind | Description |
|---------|-------------|
| `<leader>tr` | Run task (Gradle/Maven/NPM/Make) |
| `<leader>tt` | Toggle task list |
| `<leader>ti` | Task info |
| `<leader>ta` | Task actions |

### Other

| Keybind | Description |
|---------|-------------|
| `<leader>u` | Undo tree |
| `<leader>z` | Toggle Zen Mode |
| `Ctrl+\` | Toggle terminal |
| `Esc` | Clear search highlight |

---

## Plugins

### Philosophy

Every plugin is **lazy-loaded** and serves a specific purpose. No bloat, no unused features.

### UI & Navigation

- **dashboard-nvim** - Beautiful startup screen with verse
- **oil.nvim** - Edit filesystem like a buffer (replaces traditional file trees)
- **telescope.nvim** - Fuzzy finder for everything
- **dressing.nvim** - Telescope-based UI for vim.ui.select/input
- **harpoon** - ThePrimeagen's quick file bookmarks (harpoon2)
- **aerial.nvim** - LSP-powered code outline sidebar
- **lualine.nvim** - Enhanced statusline with LSP status, macro recording
- **which-key.nvim** - Popup showing keybind options
- **mini.indentscope** - Animated indent scope guides
- **mini.icons** - Modern icon support
- **noice.nvim** - Better UI for messages, cmdline, and popups
- **nvim-notify** - Beautiful notification system

### LSP & Completion

- **mason.nvim** - Package manager for LSP servers, formatters, linters, debuggers
- **nvim-lspconfig** - Using Neovim 0.11+ native APIs
- **nvim-jdtls** - Enhanced Java support with Eclipse JDTLS
- **typescript-tools.nvim** - Faster TypeScript with inlay hints
- **nvim-cmp** - Completion engine with intelligent sources
- **LuaSnip** - Snippet engine with VSCode snippet support

### Code Intelligence

- **nvim-treesitter** - Syntax highlighting via Tree-sitter parsers
- **nvim-treesitter-context** - "Sticky scroll" showing current function/class
- **nvim-ts-autotag** - Auto-close HTML/JSX tags
- **conform.nvim** - Modern formatter with multiple formatters per filetype

### Git Integration

- **gitsigns.nvim** - Git changes in sign column with inline blame
- **lazygit.nvim** - Full-featured git TUI inside Neovim

### Editing Enhancements (Mini.nvim Suite)

- **mini.pairs** - Auto-close brackets/quotes
- **mini.comment** - Toggle comments with `gc`
- **mini.surround** - Add/change/delete surrounding pairs
- **flash.nvim** - Advanced motion with treesitter support

### Debugging (DAP)

- **nvim-dap** - Debug Adapter Protocol client
- **nvim-dap-ui** - Beautiful debug UI
- **nvim-dap-go** - Go debugging (Delve)
- **nvim-dap-python** - Python debugging (debugpy)
- **nvim-dap-virtual-text** - Show variable values inline

### Database

- **vim-dadbod** - Database client
- **vim-dadbod-ui** - Database UI with connection management
- **vim-dadbod-completion** - SQL completion in nvim-cmp

### Testing

- **neotest** - Unified test runner
- **neotest-python** - pytest adapter
- **neotest-go** - Go test adapter
- **neotest-java** - JUnit adapter
- **neotest-jest** - Jest adapter

### REST & HTTP

- **rest.nvim** - HTTP client for .http files

### Session & Workflow

- **auto-session** - Auto-save/restore workspace per git branch
- **telescope-undo.nvim** - Visual undo tree
- **trouble.nvim** - Beautiful diagnostics/quickfix list
- **toggleterm.nvim** - Floating/split terminals
- **overseer.nvim** - Task runner for Gradle/Maven/NPM/Make
- **grug-far.nvim** - Project-wide find and replace
- **render-markdown.nvim** - Live markdown preview
- **todo-comments.nvim** - Highlight TODO/FIX/NOTE/WARN
- **fidget.nvim** - LSP progress notifications
- **zen-mode.nvim** - Distraction-free focus mode
- **refactoring.nvim** - Refactoring operations

### AI Tools

- **claude** (custom) - Claude AI for code explanations and guidance
- **airefactor** (custom) - Ollama-powered code refactoring

---

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── .preferences                # User preferences (mouse, ollama_model)
├── lua/
│   ├── core/
│   │   ├── options.lua        # Vim options
│   │   ├── mappings.lua       # Keybindings
│   │   ├── autocmds.lua       # Auto-commands
│   │   ├── appearance.lua     # Theme configuration
│   │   ├── preferences.lua    # Preferences system
│   │   └── project.lua        # Project type detection
│   ├── claude/                # Claude AI plugin
│   │   ├── init.lua
│   │   ├── api.lua
│   │   └── ui.lua
│   ├── airefactor/            # AI Refactor plugin (Ollama)
│   │   ├── init.lua
│   │   ├── api.lua
│   │   └── ui.lua
│   ├── overseer/template/user/ # Task runner templates
│   │   ├── gradle.lua
│   │   ├── maven.lua
│   │   ├── npm.lua
│   │   └── make.lua
│   └── plugins/
│       ├── lazy_setup.lua     # Plugin definitions
│       └── configs/           # Plugin configurations
└── ftplugin/                   # Language-specific configs
    ├── java.lua
    ├── python.lua
    ├── go.lua
    ├── c.lua
    ├── cpp.lua
    └── ...
```

---

## Setup

### AI Refactoring with Ollama

**Setup (one-time):**

```bash
# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull the model
ollama pull qwen3-coder:30b

# Start Ollama
ollama serve
```

**Usage:**
1. Select code in visual mode
2. Press `<leader>ra` or type `:AIRefactor`
3. Review side-by-side comparison
4. Press `a` to accept, `r` to reject, `q` to close

**Customization** (in `~/.config/nvim/.preferences`):
```
ollama_model=codellama:13b
```

### Claude AI Setup

```bash
# Create private file for API key
mkdir -p ~/.zsh && touch ~/.zsh/.zshenv_private && chmod 600 ~/.zsh/.zshenv_private
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.zsh/.zshenv_private
echo 'source ~/.zsh/.zshenv_private' >> ~/.zshrc
```

### Preferences System

All preferences in `~/.config/nvim/.preferences`:

```
mouse=false
ollama_model=qwen3-coder:30b
```

### Spring Boot Tools (Optional)

For enhanced Spring Boot support in Java files:

1. Download jars from [sts4 releases](https://github.com/spring-projects/sts4/releases)
2. Place in `~/.local/share/nvim/spring-boot-tools/`
3. Uncomment the bundles line in `ftplugin/java.lua`

---

## Language Support

### Java

- **LSP**: Eclipse JDTLS
- **Formatter**: google-java-format
- **Debugger**: java-debug-adapter + java-test
- **Features**: Auto-format on save, organize imports, Spring Boot tools

### C/C++

- **LSP**: clangd
- **Formatter**: clang-format
- **Debugger**: codelldb
- **Features**: Compile commands, valgrind, GDB integration

### C#

- **LSP**: OmniSharp
- **Formatter**: csharpier
- **Debugger**: netcoredbg

### Go

- **LSP**: gopls
- **Formatters**: goimports → gofumpt
- **Debugger**: delve (via nvim-dap-go)
- **Features**: Staticcheck, unused params detection

### Python

- **LSP**: pyright
- **Formatters**: isort → black
- **Linter**: ruff
- **Debugger**: debugpy

### TypeScript/JavaScript/React

- **LSP**: typescript-tools
- **Formatters**: prettier → eslint_d
- **Debugger**: js-debug-adapter
- **Features**: Inlay hints, auto-import

### HTML/CSS/SCSS

- **LSP**: html-lsp, css-lsp, emmet-ls
- **Formatter**: prettier

### Bash/Zsh

- **LSP**: bash-language-server
- **Linter**: shellcheck

### Lua

- **LSP**: lua-language-server
- **Formatter**: stylua

---

## Session Management

- **Auto-save**: Workspace saved when exiting nvim
- **Auto-restore**: Layout restored when reopening in same directory
- **Per git branch**: Each branch gets its own session
- **Session picker**: `<leader>fs` to find, `<leader>fd` to delete

---

## Performance

**Startup Time**: 67ms average

```
Benchmark 1: nvim +q
  Time (mean ± σ):      66.9 ms ±   6.1 ms
  Range (min … max):    56.3 ms …  82.9 ms    100 runs
```

### Benchmark Your Config

```bash
time nvim +q
nvim --startuptime startup.log +q && cat startup.log
:Lazy profile
```

---

## Requirements

- **Neovim** 0.11+
- **Git**
- **Ripgrep** (for telescope live_grep, grug-far)
- **Make** (for telescope-fzf-native)
- **Node.js** (for some LSP servers)
- **curl** (for Claude AI plugin)
- **LazyGit** (optional, for `<leader>gg`)
- **Nerd Font** (for icons)
- **jq** (optional, for REST client JSON formatting)

---

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone https://github.com/JacobSmxth/Ichthys ~/.config/nvim

# Set up Claude AI (optional)
mkdir -p ~/.zsh && touch ~/.zsh/.zshenv_private && chmod 600 ~/.zsh/.zshenv_private
echo 'export ANTHROPIC_API_KEY="your-key"' >> ~/.zsh/.zshenv_private
echo 'source ~/.zsh/.zshenv_private' >> ~/.zshrc

# Open nvim - plugins auto-install
nvim
```

---

## Design Principles

1. **Personalized**: Only languages I use = faster everything
2. **Performance-obsessed**: 67ms startup through strategic lazy loading
3. **Modern**: Neovim 0.11+ APIs that most configs haven't adopted
4. **Production-ready**: Every language has LSP + formatter + linter + debugger
5. **AI-Enhanced**: Local Ollama refactoring without cloud dependency
6. **No bloat**: If I don't use it, it's not here
7. **Understanding over abstraction**: Native LSP over wrapper plugins

---

## Who This Is For

**This config is for you if:**
- You work with Java, C/C++, C#, Go, Python, TypeScript/JavaScript
- You want a **fast**, opinionated setup
- You value performance over trying every new plugin
- You want debugger support, not just LSP
- You appreciate backend-focused development

**This config is NOT for you if:**
- You need Rust, Zig, Haskell, or other languages not listed
- You want a minimal "learn Neovim" setup (try kickstart.nvim)
- You prefer distributions like LazyVim/NvChad

---

## Fork It, Make It Yours

This is my **personal** config. Fork it, remove what you don't need, add your own keybinds, and make it yours.

---

"Commit thy works unto the Lord, and thy thoughts shall be established." - Proverbs 16:3 KJV
