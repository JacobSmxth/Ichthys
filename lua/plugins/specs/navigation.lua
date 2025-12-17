-- Navigation plugins: telescope, oil, harpoon

return {
  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("plugins.configs.telescope")
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Oil (file explorer as buffer)
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        columns = { "icon", "permissions", "size", "mtime" },
        buf_options = { buflisted = false, bufhidden = "hide" },
        win_options = {
          wrap = false,
          signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        delete_to_trash = false,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-v>"] = "actions.select_vsplit",
          ["<C-x>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<C-r>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name) return vim.startswith(name, ".") end,
          is_always_hidden = function() return false end,
          sort = { { "type", "asc" }, { "name", "asc" } },
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = "rounded",
          win_options = { winblend = 0 },
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          max_height = 0.9,
          min_height = { 5, 0.1 },
          border = "rounded",
          win_options = { winblend = 0 },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          border = "rounded",
          minimized_border = "none",
          win_options = { winblend = 0 },
        },
      })

      -- Sidebar toggle
      local oil_sidebar_winid = nil

      local function toggle_oil_sidebar()
        if oil_sidebar_winid then
          if vim.api.nvim_win_is_valid(oil_sidebar_winid) then
            local buf = vim.api.nvim_win_get_buf(oil_sidebar_winid)
            if not vim.api.nvim_buf_is_valid(buf) then
              oil_sidebar_winid = nil
            else
              vim.api.nvim_win_close(oil_sidebar_winid, true)
              oil_sidebar_winid = nil
              return
            end
          else
            oil_sidebar_winid = nil
          end
        end

        if not oil_sidebar_winid then
          vim.cmd("topleft vsplit")
          require("oil").open()
          oil_sidebar_winid = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_width(oil_sidebar_winid, 35)
          vim.w.is_oil_sidebar = true
        end
      end

      -- Sidebar keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          if vim.w.is_oil_sidebar then
            vim.keymap.set("n", "<C-h>", "<C-w>h", { buffer = true })
            vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true })
            vim.keymap.set("n", "<C-j>", "<C-w>j", { buffer = true })
            vim.keymap.set("n", "<C-k>", "<C-w>k", { buffer = true })

            vim.keymap.set("n", "<CR>", function()
              local oil = require("oil")
              local entry = oil.get_cursor_entry()
              if not entry then return end

              if entry.type == "file" then
                local dir = oil.get_current_dir()
                local filepath = dir .. entry.name
                local current_win = vim.api.nvim_get_current_win()
                local windows = vim.api.nvim_list_wins()
                local target_win = nil

                for _, win in ipairs(windows) do
                  local win_buf = vim.api.nvim_win_get_buf(win)
                  local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = win_buf })
                  local win_config = vim.api.nvim_win_get_config(win)
                  if win ~= current_win and buf_ft ~= "oil" and win_config.relative == "" then
                    target_win = win
                    break
                  end
                end

                if target_win then
                  vim.api.nvim_set_current_win(target_win)
                  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
                else
                  vim.cmd("wincmd l")
                  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
                end
              else
                oil.select()
              end
            end, { buffer = true, desc = "Open in main window" })
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "BufWipeout", "WinClosed" }, {
        pattern = "*",
        callback = function(args)
          if oil_sidebar_winid and args.match == tostring(oil_sidebar_winid) then
            oil_sidebar_winid = nil
          end
        end,
      })

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open Oil (float)" })
      vim.keymap.set("n", "<leader>e", toggle_oil_sidebar, { desc = "Toggle Oil sidebar" })
    end,
  },

  -- Harpoon (quick file navigation)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Harpoon next" })
      vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Harpoon prev" })
    end,
  },
}
