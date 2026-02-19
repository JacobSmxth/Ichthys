local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)
map("n", "<Left>", "<Nop>", opts)
map("n", "<Right>", "<Nop>", opts)
map("i", "<Up>", "<Nop>", opts)
map("i", "<Down>", "<Nop>", opts)
map("i", "<Left>", "<Nop>", opts)
map("i", "<Right>", "<Nop>", opts)
map("v", "<Up>", "<Nop>", opts)
map("v", "<Down>", "<Nop>", opts)
map("v", "<Left>", "<Nop>", opts)
map("v", "<Right>", "<Nop>", opts)

map("n", "<leader>i", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { noremap = true, silent = true, desc = "Fix indentation" })

map("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", { noremap = true, silent = true, desc = "Fuzzy find in buffer" })

map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Command palette (Zed-style Cmd+Shift+P)
map("n", "<leader>p", function()
  require("telescope.builtin").commands(require("telescope.themes").get_dropdown({
    borderchars = {
      prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
  }))
end, { noremap = true, silent = true, desc = "Command palette" })

-- Command history
map("n", "<leader>:", ":Telescope command_history<CR>", { noremap = true, silent = true, desc = "Command history" })

-- Quick recent files (project scoped)
map("n", "<leader>o", function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end, { noremap = true, silent = true, desc = "Recent project files" })
map("n", "<leader>fo", function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end, { noremap = true, silent = true, desc = "Recent project files" })

-- Telescope finder mappings
map("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })
map("n", "<leader>fG", function()
  require("telescope.builtin").live_grep({
    prompt_title = "Regex Search (entire codebase)",
    additional_args = function()
      return { "--hidden", "--pcre2" }
    end,
  })
end, { noremap = true, silent = true, desc = "Regex grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true, desc = "Find buffers" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true, desc = "Find help" })
map("n", "<leader>fk", ":Telescope keymaps<CR>", { noremap = true, silent = true, desc = "Find keymaps" })
map("n", "<leader>fc", ":Telescope commands<CR>", { noremap = true, silent = true, desc = "Find commands" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { noremap = true, silent = true, desc = "Recent files" })
map("n", "<leader>ft", ":Telescope filetypes<CR>", { noremap = true, silent = true, desc = "Find filetypes" })
map("n", "<leader>fD", function()
  local ok_pickers, pickers = pcall(require, "telescope.pickers")
  local ok_finders, finders = pcall(require, "telescope.finders")
  local ok_conf, conf = pcall(require, "telescope.config")
  local ok_actions, actions = pcall(require, "telescope.actions")
  local ok_action_state, action_state = pcall(require, "telescope.actions.state")

  if not (ok_pickers and ok_finders and ok_conf and ok_actions and ok_action_state) then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end

  local cmd = vim.fn.executable("fd") == 1
    and "fd --type d --hidden --exclude .git --max-depth 5"
    or "find . -type d -not -path '*/\\.git/*' 2>/dev/null"

  pickers.new({}, {
    prompt_title = "Find Directories",
    finder = finders.new_oneshot_job(vim.split(cmd, " ")),
    sorter = conf.values.file_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("cd " .. vim.fn.fnameescape(selection[1]))
          vim.notify("Changed directory to: " .. selection[1], vim.log.levels.INFO)
        end
      end)
      return true
    end,
  }):find()
end, { noremap = true, silent = true, desc = "Find directories" })

-- Man pages (using Telescope builtin)
map("n", "<leader>fm", ":Telescope man_pages<CR>", { noremap = true, silent = true, desc = "Find man pages" })

map("n", "<leader><leader>", "<C-^>", opts)

map("i", "jj", "<Esc>", opts)

-- Terminal mode escape
map("t", "jj", "<C-\\><C-n>", opts)

-- Paste from system clipboard in command mode
map("c", "<C-v>", "<C-r>+", { noremap = true, desc = "Paste from system clipboard" })

map("n", "<S-L>", ":bnext<CR>", opts)
map("n", "<S-H>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })

map("n", "<Esc>", ":noh<CR>", opts)

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window splits
map("n", "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
map("n", "<leader>ws", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })
map("n", "<leader>wq", ":close<CR>", { noremap = true, silent = true, desc = "Close window" })
map("n", "<leader>wo", ":only<CR>", { noremap = true, silent = true, desc = "Close other windows" })

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines up/down with Alt+j/k
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Claude AI mappings
map("v", "<leader>ce", ":'<,'>Explain<CR>", { noremap = true, silent = true, desc = "Claude: Explain code" })
map("n", "<leader>cq", function()
  vim.ui.input({ prompt = "Ask Claude: " }, function(input)
    if input and input ~= "" then
      vim.cmd("Guide " .. input)
    end
  end)
end, { noremap = true, silent = true, desc = "Claude: Ask question" })

-- Quick project info popup
map("n", "<leader>d", function()
  require("plugins.configs.project-info").show()
end, { noremap = true, silent = true, desc = "Project info" })

-- Quickfix / location list navigation
map("n", "]q", "<cmd>cnext<cr>zz", { noremap = true, silent = true, desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<cr>zz", { noremap = true, silent = true, desc = "Prev quickfix" })
map("n", "]Q", "<cmd>clast<cr>zz", { noremap = true, silent = true, desc = "Last quickfix" })
map("n", "[Q", "<cmd>cfirst<cr>zz", { noremap = true, silent = true, desc = "First quickfix" })
map("n", "]l", "<cmd>lnext<cr>zz", { noremap = true, silent = true, desc = "Next location list" })
map("n", "[l", "<cmd>lprev<cr>zz", { noremap = true, silent = true, desc = "Prev location list" })

-- Smart yanks for file info
map("n", "<leader>yf", '<cmd>let @+ = expand("%")<cr>', { noremap = true, silent = true, desc = "Yank file path" })
map("n", "<leader>yF", '<cmd>let @+ = expand("%:p")<cr>', { noremap = true, silent = true, desc = "Yank full path" })
map("n", "<leader>yn", '<cmd>let @+ = expand("%:t")<cr>', { noremap = true, silent = true, desc = "Yank file name" })
map("n", "<leader>yl", function()
  local line = vim.fn.expand("%") .. ":" .. vim.fn.line(".")
  vim.fn.setreg("+", line)
  vim.notify("Yanked: " .. line, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Yank file:line" })

-- Visual * search
map("v", "*", function()
  local saved = vim.fn.getreg("z")
  vim.cmd('normal! "zy')
  local pattern = vim.fn.escape(vim.fn.getreg("z"), "\\[]^$.*")
  vim.fn.setreg("/", "\\V" .. pattern)
  vim.cmd("normal! n")
  vim.fn.setreg("z", saved)
end, { noremap = true, silent = true, desc = "Search visual selection" })

-- Project command memory (per cwd)
local last_cmd = {}
map("n", "<leader>c.", function()
  local cwd = vim.fn.getcwd()
  if last_cmd[cwd] then
    vim.cmd("TermExec cmd='" .. last_cmd[cwd] .. "'")
  else
    vim.ui.input({ prompt = "Command: " }, function(cmd)
      if cmd and cmd ~= "" then
        last_cmd[cwd] = cmd
        vim.cmd("TermExec cmd='" .. cmd .. "'")
      end
    end)
  end
end, { noremap = true, silent = true, desc = "Run/set project command" })

-- Toggle between Java impl/test files
map("n", "<leader>to", function()
  local file = vim.fn.expand("%:t")
  local dir = vim.fn.expand("%:p:h")

  if file:match("Test%.java$") then
    local impl = file:gsub("Test%.java$", ".java")
    local impl_path = dir .. "/" .. impl
    if vim.loop.fs_stat(impl_path) then
      vim.cmd("edit " .. vim.fn.fnameescape(impl_path))
    else
      local ok = pcall(vim.cmd, "find " .. vim.fn.fnameescape(impl))
      if not ok then
        vim.notify("Impl not found: " .. impl, vim.log.levels.WARN)
      end
    end
  elseif file:match("%.java$") then
    local test = file:gsub("%.java$", "Test.java")
    local test_path = dir .. "/" .. test
    if vim.loop.fs_stat(test_path) then
      vim.cmd("edit " .. vim.fn.fnameescape(test_path))
    else
      local ok = pcall(vim.cmd, "find " .. vim.fn.fnameescape(test))
      if not ok then
        vim.notify("Test not found: " .. test, vim.log.levels.WARN)
      end
    end
  else
    vim.notify("Not a Java file", vim.log.levels.WARN)
  end
end, { noremap = true, silent = true, desc = "Toggle test/implementation" })

-- View messages
map("n", "<leader>fM", ":Noice telescope<CR>", { noremap = true, silent = true, desc = "View messages (Noice)" })
