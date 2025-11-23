local M = {}

local api_key = nil

local function get_api_key()
  if api_key then
    return api_key
  end

  api_key = os.getenv("ANTHROPIC_API_KEY")
  if not api_key or api_key == "" then
    api_key = vim.fn.inputsecret("Enter Anthropic API key: ")
    if not api_key or api_key == "" then
      return nil
    end
  end

  return api_key
end

local function escape_json(str)
  str = str:gsub("\\", "\\\\")
  str = str:gsub('"', '\\"')
  str = str:gsub("\n", "\\n")
  str = str:gsub("\r", "\\r")
  str = str:gsub("\t", "\\t")
  return str
end

local function parse_response(json_str)
  local content_match = json_str:match('"text"%s*:%s*"(.-)"[^"]*}%s*]')
  if not content_match then
    return json_str
  end

  local text = content_match:gsub("\\n", "\n")
  text = text:gsub("\\r", "\r")
  text = text:gsub("\\t", "\t")
  text = text:gsub('\\"', '"')
  text = text:gsub("\\\\", "\\")

  return text
end

function M.call_claude(user_message, callback)
  local key = get_api_key()
  if not key then
    vim.api.nvim_err_writeln("No API key provided")
    return
  end

  local escaped_message = escape_json(user_message)

  local system_prompt = [[You are a senior developer who explains code and concepts with extreme clarity and zero fluff.

Rules:
- Never lecture. Be concise and precise.
- Use simple words. Define jargon once if needed.
- Always use markdown (headings, bullets, code fences).
- For code explanations: go line-by-line or block-by-block only when it adds clarity; otherwise summarize intent.
- Never repeat the input code unless showing a fix.
- When a concept has official docs, just link them instead of explaining from scratch.
- Max 400 words total.

Detect the task from the first word of the user message:

If user message starts with "Explain":
- Summarize what the code does in 1 sentence
- Explain only the tricky/important parts
- List potential bugs or gotchas (if any)
- End with 1-line improvement or "looks good"

If user message starts with "Guide":
  - First check if the request contains "build" or "write" or "implement"
  - If yes → respond ONLY with the Resources section (see special case below)
  - If no → normal guide:
    • 2–4 sentence conceptual overview
    • 1 tiny working example (if helpful)
    • 2–3 best resources with direct links (official docs first)

Special case – "build / write / implement" requests:
Respond EXACTLY like this and nothing else:

### Resources only
• [Best short tutorial] – direct link
• [Next best / official docs] – direct link
• [One more high-quality resource] – direct link

Output format for normal Explain / Guide (strict):

### Summary
<1 sentence>

### Details
• bullet points only

### Gotchas / Tips
• only if real issues exist

### Resources
• Title – direct link
• max 3

Respond now.]]

  local escaped_system = escape_json(system_prompt)

  local json_payload = string.format(
    [[{"model":"claude-haiku-4-5-20251001","max_tokens":1024,"temperature":0,"system":"%s","messages":[{"role":"user","content":"%s"}]}]],
    escaped_system,
    escaped_message
  )

  local tmp_file = os.tmpname()
  local f = io.open(tmp_file, "w")
  if not f then
    vim.api.nvim_err_writeln("Could not create temp file")
    return
  end
  f:write(json_payload)
  f:close()

  local curl_cmd = string.format(
    [[curl -s -X POST https://api.anthropic.com/v1/messages -H "Content-Type: application/json" -H "x-api-key: %s" -H "anthropic-version: 2023-06-01" -d @%s]],
    key,
    tmp_file
  )

  vim.fn.jobstart(curl_cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local result = table.concat(data, "\n")
        os.remove(tmp_file)
        local parsed = parse_response(result)
        callback(parsed)
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        local err = table.concat(data, "\n")
        if err ~= "" then
          vim.schedule(function()
            vim.api.nvim_err_writeln("Error: " .. err)
          end)
        end
      end
    end,
    on_exit = function()
      os.remove(tmp_file)
    end,
  })
end

return M
