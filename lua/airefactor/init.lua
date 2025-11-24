local M = {}

local api = require("airefactor.api")
local ui = require("airefactor.ui")

M.config = {
  model = "qwen3-coder:30b",
  host = "http://localhost:11434",
  timeout = 60000,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end
function M.refactor(opts)
  opts = opts or {}

  local start_line, end_line

  if opts.line1 and opts.line2 then
    start_line = opts.line1
    end_line = opts.line2
  else
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    start_line = start_pos[2]
    end_line = end_pos[2]
  end

  if not start_line or not end_line or start_line == 0 or end_line == 0 then
    vim.notify("No visual selection found. Please select code first.", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local code = table.concat(lines, "\n")

  if code == "" or code == nil then
    vim.notify("No code selected", vim.log.levels.WARN)
    return
  end

  local filetype = vim.bo.filetype
  local lang = filetype ~= "" and filetype or "code"

  vim.notify("Analyzing code for refactoring suggestions...", vim.log.levels.INFO)
  local prompt = string.format([[You are an expert code reviewer and refactoring assistant.

CRITICAL INSTRUCTIONS:
- The user selected a CODE SNIPPET, NOT a complete file
- ONLY refactor the exact snippet provided - do NOT add surrounding context
- Do NOT add imports, function definitions, class definitions, or main blocks
- The refactored code must be a DROP-IN replacement for the selected lines
- If new imports are needed, mention them separately in IMPORTS section

Analyze the following %s code snippet and provide refactoring suggestions if needed.

Your response MUST follow this exact format:

DECISION: [REFACTOR or NO_REFACTOR]

EXPLANATION:
[Explain your decision in 2-3 sentences]

REFACTORED_CODE:
```%s
[ONLY the refactored snippet - must be exact drop-in replacement]
[Do NOT add imports, function wrappers, or any surrounding context]
```

IMPORTS:
[List any new imports needed, or "None"]
Example: import { useState } from 'react';

CHANGES:
- [List specific changes made, or "None" if NO_REFACTOR]

Focus on:
- Code clarity and readability within the snippet
- Performance improvements
- Best practices for %s
- Reducing complexity
- Better variable/function names

Only suggest refactoring if there are meaningful improvements. If the code is already good, say NO_REFACTOR.

CODE SNIPPET TO ANALYZE:
```%s
%s
```]], lang, lang, lang, lang, code)

  api.generate(prompt, M.config, function(response, error)
    if error then
      vim.notify("Refactoring failed: " .. error, vim.log.levels.ERROR)
      return
    end

    local decision, explanation, refactored_code, imports, changes = M.parse_response(response)

    if decision == "NO_REFACTOR" then
      ui.show_no_refactor(explanation)
    else
      ui.show_refactor(code, refactored_code, explanation, imports, changes, start_line, end_line, filetype)
    end
  end)
end
function M.parse_response(response)
  local decision = "NO_REFACTOR"
  local explanation = ""
  local refactored_code = ""
  local imports = "None"
  local changes = {}

  local decision_match = response:match("DECISION:%s*([^\n]+)")
  if decision_match then
    decision = decision_match:match("REFACTOR") and "REFACTOR" or "NO_REFACTOR"
  end

  local explanation_match = response:match("EXPLANATION:%s*(.-)%s*REFACTORED_CODE:")
  if explanation_match then
    explanation = vim.trim(explanation_match)
  end

  local code_match = response:match("REFACTORED_CODE:%s*```[%w]*%s*(.-)%s*```")
  if code_match then
    refactored_code = vim.trim(code_match)
  end

  local imports_match = response:match("IMPORTS:%s*(.-)%s*CHANGES:")
  if imports_match then
    imports = vim.trim(imports_match)
  end

  local changes_match = response:match("CHANGES:%s*(.-)$")
  if changes_match then
    for change in changes_match:gmatch("%-([^\n]+)") do
      table.insert(changes, vim.trim(change))
    end
  end

  return decision, explanation, refactored_code, imports, changes
end

return M
