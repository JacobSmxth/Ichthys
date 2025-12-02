-- Only run for c files
if vim.bo.filetype ~= "c" then
  return
end

require("core.compile_utils").setup_compiled_lang({
  name = "C",
  compiler = "gcc",
  flags = "-Wall -Wextra",
})
