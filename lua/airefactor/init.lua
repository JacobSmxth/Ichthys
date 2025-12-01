local M = {}

local api = require("airefactor.api")
local ui = require("airefactor.ui")

M.config = {
  model = "qwen3-coder:30b",
  host = "http://localhost:11434",
  timeout = 60000,
}

-- Store conversation context for iterative refinement
M.conversation = {
  history = {},
  original_code = nil,
  current_refactored = nil,
  start_line = nil,
  end_line = nil,
  filetype = nil,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end
function M.refactor(opts)
  opts = opts or {}

  -- Check Ollama availability first
  api.check_ollama_running(M.config, function(is_running)
    if not is_running then
      vim.notify(
        "Ollama is not running at " .. M.config.host .. ". Please start Ollama first.",
        vim.log.levels.ERROR
      )
      return
    end
  end)

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

  -- Reset conversation for new refactor
  M.conversation.history = {}
  M.conversation.original_code = code
  M.conversation.current_refactored = nil
  M.conversation.start_line = start_line
  M.conversation.end_line = end_line
  M.conversation.filetype = filetype

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
      M.conversation.current_refactored = refactored_code
      table.insert(M.conversation.history, {
        role = "assistant",
        explanation = explanation,
        code = refactored_code,
      })
      ui.show_refactor(code, refactored_code, explanation, imports, changes, start_line, end_line, filetype, M)
    end
  end)
end

-- New function: Send feedback to refine the refactoring
function M.send_feedback(feedback_message)
  if not M.conversation.original_code then
    vim.notify("No active refactoring session", vim.log.levels.WARN)
    return
  end

  local lang = M.conversation.filetype ~= "" and M.conversation.filetype or "code"

  vim.notify("Refining based on your feedback...", vim.log.levels.INFO)

  -- Build conversation history
  local history_text = ""
  for i, msg in ipairs(M.conversation.history) do
    if msg.role == "assistant" then
      history_text = history_text .. string.format("\n[Previous suggestion %d]\n%s\n```%s\n%s\n```\n",
        i, msg.explanation, lang, msg.code)
    elseif msg.role == "user" then
      history_text = history_text .. string.format("\n[Your feedback %d]: %s\n", i, msg.feedback)
    end
  end

  local prompt = string.format([[You are an expert code reviewer and refactoring assistant.

CONTEXT:
You previously suggested refactorings for this code snippet. The user has provided feedback.
%s

CRITICAL INSTRUCTIONS:
- The user selected a CODE SNIPPET, NOT a complete file
- ONLY refactor the exact snippet provided - do NOT add surrounding context
- Do NOT add imports, function definitions, class definitions, or main blocks
- The refactored code must be a DROP-IN replacement for the selected lines
- If new imports are needed, mention them separately in IMPORTS section

USER'S NEW FEEDBACK:
%s

ORIGINAL CODE SNIPPET:
```%s
%s
```

CURRENT REFACTORED VERSION:
```%s
%s
```

Based on the user's feedback, provide an UPDATED refactoring.

Your response MUST follow this exact format:

DECISION: REFACTOR

EXPLANATION:
[Explain what you changed based on the user's feedback in 2-3 sentences]

REFACTORED_CODE:
```%s
[ONLY the refactored snippet - must be exact drop-in replacement]
[Do NOT add imports, function wrappers, or any surrounding context]
```

IMPORTS:
[List any new imports needed, or "None"]

CHANGES:
- [List specific changes made based on feedback]
]], history_text, feedback_message, lang, M.conversation.original_code,
    lang, M.conversation.current_refactored, lang)

  -- Add user feedback to history
  table.insert(M.conversation.history, {
    role = "user",
    feedback = feedback_message,
  })

  api.generate(prompt, M.config, function(response, error)
    if error then
      vim.notify("Refactoring failed: " .. error, vim.log.levels.ERROR)
      return
    end

    local decision, explanation, refactored_code, imports, changes = M.parse_response(response)

    M.conversation.current_refactored = refactored_code
    table.insert(M.conversation.history, {
      role = "assistant",
      explanation = explanation,
      code = refactored_code,
    })

    ui.show_refactor(
      M.conversation.original_code,
      refactored_code,
      explanation,
      imports,
      changes,
      M.conversation.start_line,
      M.conversation.end_line,
      M.conversation.filetype,
      M
    )
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
