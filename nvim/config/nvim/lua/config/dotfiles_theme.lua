-- Personal synchronization only. Highlights live in xcode-pitch-theme.
local M = {}
local uv = vim.uv or vim.loop
local root = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/dotfiles-theme"
local state_path = root .. "/state.json"
local palette_path = vim.env.DOTFILES_THEME_PALETTES or (root .. "/palettes.json")
vim.opt.rtp:append(vim.env.DOTFILES_THEME_NVIM or (root .. "/neovim"))
local active, applying, timer, querying, last_query = nil, false, nil, false, 0
local automatic_mode = vim.o.background

local function read_json(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  local parsed, value = pcall(vim.json.decode, table.concat(lines, "\n"))
  return parsed and type(value) == "table" and value or nil
end

local function state()
  local value = read_json(state_path) or {}
  return {
    mode = (value.mode == "dark" or value.mode == "light") and value.mode or "auto",
    light = value.light == "ayu-light" and "ayu-light" or "xcode-light",
  }
end

function M.apply()
  if applying then
    return
  end
  local s = state()
  local mode = s.mode == "auto" and automatic_mode or s.mode
  local key = mode == "dark" and "xcode-dark" or s.light
  local palettes = read_json(palette_path)
  local ok, renderer = pcall(require, "xcode_pitch")
  if not palettes or not palettes[key] or not ok then
    vim.notify("Dotfiles theme assets missing: run theme install", vim.log.levels.WARN)
    return
  end
  applying = true
  renderer.apply(palettes[key], { name = "dotfiles_pitch" })
  active = key
  applying = false
end

local function refresh(force)
  local s = state()
  local mode = s.mode == "auto" and automatic_mode or s.mode
  local key = mode == "dark" and "xcode-dark" or s.light
  if force or key ~= active then
    M.apply()
  end
  if s.mode == "auto" and vim.fn.has("macunix") == 1 and not querying
    and uv.now() - last_query >= 5000 then
    querying = true
    last_query = uv.now()
    vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true, timeout = 3000 }, function(result)
      vim.schedule(function()
        querying = false
        local detected = vim.trim(result.stdout or ""):lower() == "dark" and "dark" or "light"
        if detected ~= automatic_mode then
          automatic_mode = detected
          refresh(false)
        end
      end)
    end)
  end
end

function M.setup()
  if timer then
    return
  end
  local group = vim.api.nvim_create_augroup("DotfilesTheme", { clear = true })
  vim.api.nvim_create_autocmd("FocusGained", { group = group, callback = function() refresh(true) end })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "background",
    callback = function()
      if applying then
        return
      end
      if state().mode == "auto" then
        automatic_mode = vim.o.background
      end
      refresh(true)
    end,
  })
  timer = uv.new_timer()
  timer:start(1000, 1000, vim.schedule_wrap(function() refresh(false) end))
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      timer:stop()
      timer:close()
    end,
  })
end

return M
