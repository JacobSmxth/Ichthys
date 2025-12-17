-- Misc plugins: typing practice, package.json info

return {
  -- Typing practice
  {
    "nvzone/typr",
    dependencies = { "nvzone/volt" },
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },

  -- Package.json version info
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    config = function()
      require("package-info").setup({
        autostart = true,
        hide_up_to_date = true,
        hide_unstable_versions = false,
      })
    end,
  },
}
