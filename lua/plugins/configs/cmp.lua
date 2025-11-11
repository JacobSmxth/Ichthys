-- Completion setup

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),

    -- Trigger
    ["<C-Space>"] = cmp.mapping.complete(),

    -- Close
    ["<C-e>"] = cmp.mapping.abort(),

    -- Confirm
    ["<CR>"] = cmp.mapping.confirm({ select = true }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    -- Vim-style nav
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-k>"] = cmp.mapping.select_prev_item(),
  }),

  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }),

  window = {
    completion = cmp.config.window.bordered({
      border = "single",
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
    }),
    documentation = cmp.config.window.bordered({
      border = "single",
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
    }),
  },

  formatting = {
    format = function(entry, vim_item)
      -- Item icons
      local kind_icons = {
        Text = "[TXT]",
        Method = "[MTH]",
        Function = "[FN]",
        Constructor = "[CON]",
        Field = "[FLD]",
        Variable = "[VAR]",
        Class = "[CLS]",
        Interface = "[INT]",
        Module = "[MOD]",
        Property = "[PRP]",
        Unit = "[UNT]",
        Value = "[VAL]",
        Enum = "[ENM]",
        Keyword = "[KEY]",
        Snippet = "[SNP]",
        Color = "[COL]",
        File = "[FIL]",
        Reference = "[REF]",
        Folder = "[DIR]",
        EnumMember = "[MBR]",
        Constant = "[CST]",
        Struct = "[STR]",
        Event = "[EVT]",
        Operator = "[OPR]",
        TypeParameter = "[TYP]",
      }

      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
      })[entry.source.name]

      return vim_item
    end,
  },

  experimental = {
    ghost_text = false,
  },
})
