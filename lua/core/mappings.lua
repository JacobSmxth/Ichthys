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

-- <leader>e is now handled by Oil config in lazy_setup.lua

map("n", "<leader>i", function()
  local view = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.winrestview(view)
end, { noremap = true, silent = true, desc = "Fix indentation" })

map("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", { noremap = true, silent = true, desc = "Fuzzy find in buffer" })

map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Quick recent files (project scoped)
map("n", "<leader>o", function()
  require("telescope.builtin").oldfiles({ only_cwd = true })
end, { noremap = true, silent = true, desc = "Recent project files" })

-- Telescope finder mappings
map("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live grep" })
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

  -- Get directories using fd or find
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
          -- Open Oil in the selected directory
          local oil_ok, oil = pcall(require, "oil")
          if oil_ok then
            oil.open(selection[1])
          else
            -- Fallback: just cd if Oil isn't available
            vim.cmd("cd " .. selection[1])
            vim.notify("Changed directory to: " .. selection[1], vim.log.levels.INFO)
          end
        end
      end)
      return true
    end,
  }):find()
end, { noremap = true, silent = true, desc = "Find directories" })
map("n", "<leader>fs", ":AutoSession search<CR>", { noremap = true, silent = true, desc = "Find sessions" })
map("n", "<leader>fd", function()
  local ok_pickers, pickers = pcall(require, "telescope.pickers")
  local ok_finders, finders = pcall(require, "telescope.finders")
  local ok_conf, conf = pcall(require, "telescope.config")
  local ok_actions, actions = pcall(require, "telescope.actions")
  local ok_action_state, action_state = pcall(require, "telescope.actions.state")

  if not (ok_pickers and ok_finders and ok_conf and ok_actions and ok_action_state) then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end

  -- Function to get current sessions from filesystem
  local function get_sessions()
    local sessions = vim.fn.glob(vim.fn.stdpath("data") .. "/sessions/*.vim", false, true)
    local session_names = {}

    for _, session_path in ipairs(sessions) do
      local name = vim.fn.fnamemodify(session_path, ":t:r")
      -- Decode the session name (auto-session uses URL encoding)
      name = name:gsub("%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
      end)
      table.insert(session_names, { name = name, path = session_path })
    end

    return session_names
  end

  local session_names = get_sessions()

  if #session_names == 0 then
    vim.notify("No sessions found", vim.log.levels.WARN)
    return
  end

  local function delete_session(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    if not selection then return end

    local ok = os.remove(selection.value.path)
    if ok then
      vim.notify("Deleted: " .. selection.value.name, vim.log.levels.INFO)

      -- Re-scan filesystem for remaining sessions
      local remaining_sessions = get_sessions()

      -- If no sessions left, close the picker
      if #remaining_sessions == 0 then
        vim.notify("All sessions deleted", vim.log.levels.INFO)
        actions.close(prompt_bufnr)
        return
      end

      -- Refresh the picker with current filesystem state
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      current_picker:refresh(finders.new_table({
        results = remaining_sessions,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }), { reset_prompt = false })
    else
      vim.notify("Failed to delete session", vim.log.levels.ERROR)
    end
  end

  pickers.new({}, {
    prompt_title = "Delete Session (Enter to delete, Esc to cancel)",
    finder = finders.new_table({
      results = session_names,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Enter deletes the selected session
      actions.select_default:replace(function()
        delete_session(prompt_bufnr)
      end)

      -- dd also deletes (like harpoon)
      map("n", "dd", function()
        delete_session(prompt_bufnr)
      end)

      return true
    end,
  }):find()
end, { noremap = true, silent = true, desc = "Delete session" })
map("n", "<leader>fm", function()
  local ok_pickers, pickers = pcall(require, "telescope.pickers")
  local ok_finders, finders = pcall(require, "telescope.finders")
  local ok_conf, conf = pcall(require, "telescope.config")
  local ok_actions, actions = pcall(require, "telescope.actions")
  local ok_action_state, action_state = pcall(require, "telescope.actions.state")

  if not (ok_pickers and ok_finders and ok_conf and ok_actions and ok_action_state) then
    vim.notify("Telescope not available", vim.log.levels.ERROR)
    return
  end

  local man_pages = {}

  -- Use async job instead of blocking io.popen
  local job_complete = false
  local job_id = vim.fn.jobstart("man -k . 2>/dev/null | awk '{print $1}' | sort -u", {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, page in ipairs(data) do
          if page and page ~= "" then
            table.insert(man_pages, page)
          end
        end
      end
    end,
    on_exit = function()
      job_complete = true
    end,
  })

  if job_id <= 0 then
    vim.notify("Failed to get man pages", vim.log.levels.ERROR)
    return
  end

  -- Wait for job with timeout (max 3 seconds)
  local timeout = 3000
  local waited = 0
  while not job_complete and waited < timeout do
    vim.wait(50)
    waited = waited + 50
  end

  if not job_complete then
    vim.fn.jobstop(job_id)
    vim.notify("Man page search timed out", vim.log.levels.WARN)
    return
  end

  if #man_pages == 0 then
    vim.notify("No man pages found", vim.log.levels.WARN)
    return
  end

  pickers.new({}, {
    prompt_title = "Man Pages",
    finder = finders.new_table({ results = man_pages }),
    sorter = conf.values.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        vim.cmd("Man " .. selection[1])
      end)
      return true
    end,
  }):find()
end, { noremap = true, silent = true, desc = "Find man pages" })

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

map("n", "git", "vito<Esc>", { noremap = true, silent = true, desc = "Go inner tag" })
map("n", "gi\"", "vi\"o<Esc>", { noremap = true, silent = true, desc = "Go inner \"" })
map("n", "gi'", "vi'o<Esc>", { noremap = true, silent = true, desc = "Go inner '" })
map("n", "gi`", "vi`o<Esc>", { noremap = true, silent = true, desc = "Go inner `" })
map("n", "gi(", "vi(o<Esc>", { noremap = true, silent = true, desc = "Go inner (" })
map("n", "gi)", "vi)o<Esc>", { noremap = true, silent = true, desc = "Go inner )" })
map("n", "gib", "vibo<Esc>", { noremap = true, silent = true, desc = "Go inner ()" })
map("n", "gi{", "vi{o<Esc>", { noremap = true, silent = true, desc = "Go inner {" })
map("n", "gi}", "vi}o<Esc>", { noremap = true, silent = true, desc = "Go inner }" })
map("n", "giB", "viBo<Esc>", { noremap = true, silent = true, desc = "Go inner {}" })
map("n", "gi[", "vi[o<Esc>", { noremap = true, silent = true, desc = "Go inner [" })
map("n", "gi]", "vi]o<Esc>", { noremap = true, silent = true, desc = "Go inner ]" })
map("n", "gi<", "vi<o<Esc>", { noremap = true, silent = true, desc = "Go inner <" })
map("n", "gi>", "vi>o<Esc>", { noremap = true, silent = true, desc = "Go inner >" })

-- Claude AI mappings
map("v", "<leader>ce", ":'<,'>Explain<CR>", { noremap = true, silent = true, desc = "Claude: Explain code" })
map("n", "<leader>cq", function()
  vim.ui.input({ prompt = "Ask Claude: " }, function(input)
    if input and input ~= "" then
      vim.cmd("Guide " .. input)
    end
  end)
end, { noremap = true, silent = true, desc = "Claude: Ask question" })

-- Dev Dashboard
map("n", "<leader>d", function()
  require("plugins.configs.dev-dash").open_dashboard()
end, { noremap = true, silent = true, desc = "Open Dev Dashboard" })

-- Dadbod: select connection
map("n", "<leader>Dc", function()
  local dbs = require("core.databases")
  local names = vim.tbl_keys(dbs.connections)
  table.sort(names)
  vim.ui.select(names, { prompt = "Select database:" }, function(choice)
    if choice then
      dbs.connect(choice)
    end
  end)
end, { noremap = true, silent = true, desc = "Connect to database" })

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

-- Scratch buffers
map("n", "<leader>ns", function()
  vim.cmd("enew")
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "hide"
  vim.bo.swapfile = false
end, { noremap = true, silent = true, desc = "New scratch buffer" })

map("n", "<leader>nS", function()
  vim.ui.select({ "sql", "java", "json", "markdown", "lua" }, { prompt = "Filetype:" }, function(ft)
    if ft then
      vim.cmd("enew")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "hide"
      vim.bo.swapfile = false
      vim.bo.filetype = ft
    end
  end)
end, { noremap = true, silent = true, desc = "New scratch with filetype" })

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
-- Note: For full reload, restart nvim or use :Lazy reload <plugin>
-- This mapping has been removed - just restart nvim for config changes
