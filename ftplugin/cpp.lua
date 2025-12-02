-- Only run for cpp files
if vim.bo.filetype ~= "cpp" then
  return
end

require("core.compile_utils").setup_compiled_lang({
  name = "C++",
  compiler = "g++",
  flags = "-Wall -Wextra",
  std_flag = "-std=c++17",
})
