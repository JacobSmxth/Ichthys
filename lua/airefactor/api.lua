local M = {}

-- Health check for Ollama availability
function M.check_ollama_running(config, callback)
  local url = config.host .. "/api/tags"

  vim.fn.jobstart({
    "curl",
    "-s",
    "--max-time", "2",
    url,
  }, {
    on_exit = function(_, exit_code)
      vim.schedule(function()
        callback(exit_code == 0)
      end)
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

function M.generate(prompt, config, callback)
  local url = config.host .. "/api/generate"

  local data = vim.fn.json_encode({
    model = config.model,
    prompt = prompt,
    stream = false,
    options = {
      temperature = 0.3,
      top_p = 0.9,
    }
  })

  local response_body = ""

  local function on_exit(job_id, exit_code, event_type)
    vim.schedule(function()
      if exit_code ~= 0 then
        callback(nil, "Ollama request failed with code " .. exit_code)
        return
      end

      local ok, json = pcall(vim.fn.json_decode, response_body)
      if not ok then
        callback(nil, "Failed to parse Ollama response: " .. tostring(json))
        return
      end

      if json.response then
        callback(json.response, nil)
      else
        callback(nil, "No response from Ollama")
      end
    end)
  end
  vim.fn.jobstart({
    "curl",
    "-s",
    "-X", "POST",
    url,
    "-H", "Content-Type: application/json",
    "-d", data,
    "--max-time", tostring(math.floor(config.timeout / 1000))
  }, {
    on_stdout = function(_, data_chunk)
      if data_chunk then
        response_body = response_body .. table.concat(data_chunk, "")
      end
    end,
    on_stderr = function(_, data_chunk)
      if data_chunk and #data_chunk > 0 then
        local err = table.concat(data_chunk, "")
        if err ~= "" then
          vim.schedule(function()
            vim.notify("Ollama error: " .. err, vim.log.levels.ERROR)
          end)
        end
      end
    end,
    on_exit = on_exit,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

return M
