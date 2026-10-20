local M = {}
local uv = vim.uv or vim.loop
local state_path = (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/dotfiles-theme/state.json"
local palette_path = vim.env.DOTFILES_THEME_PALETTES
  or (vim.fn.resolve(vim.fn.stdpath("config")) .. "/../../../themes/palettes.json")
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
  if not palettes or not palettes[key] then
    vim.notify("Dotfiles theme: cannot read " .. palette_path, vim.log.levels.WARN)
    return
  end
  applying = true
  local p = palettes[key]
  vim.o.termguicolors = true
  vim.o.background = mode
  vim.cmd("highlight clear")
  vim.g.colors_name = "dotfiles_pitch"
  local function hl(group, fg, bg, extra)
    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", { fg = fg, bg = bg }, extra or {}))
  end
  hl("Normal", p.foreground, p.background)
  hl("NormalNC", p.foreground, p.background)
  hl("NormalFloat", p.foreground, p.surface)
  hl("FloatBorder", p.border, p.surface)
  hl("WinSeparator", p.border, p.background)
  hl("SignColumn", nil, p.background)
  hl("LineNr", p.muted, p.background)
  hl("CursorLineNr", p.foreground, p.background, { bold = true })
  hl("CursorLine", nil, p.surface)
  hl("Cursor", p.background, p.cursor)
  hl("Visual", nil, p.selection)
  hl("Search", p.background, p.yellow)
  hl("IncSearch", p.background, p.orange)
  hl("MatchParen", p.accent, p.raised, { bold = true })
  hl("NonText", p.muted)
  hl("Whitespace", p.border)
  hl("Pmenu", p.foreground, p.surface)
  hl("PmenuSel", p.foreground, p.selection)
  hl("StatusLine", p.foreground, p.surface)
  hl("StatusLineNC", p.muted, p.background)
  hl("TabLine", p.muted, p.surface)
  hl("TabLineSel", p.accent, p.background, { bold = true })
  hl("TabLineFill", nil, p.background)
  hl("Folded", p.muted, p.surface)
  hl("Title", p.accent, nil, { bold = true })
  hl("Directory", p.blue)
  hl("ErrorMsg", p.red)
  hl("WarningMsg", p.yellow)
  for group, role in pairs({
    Comment = "comment", Constant = "number", String = "string", Character = "string",
    Number = "number", Boolean = "number", Float = "number", Identifier = "variable",
    Function = "function", Statement = "keyword", Conditional = "keyword", Repeat = "keyword",
    Label = "keyword", Operator = "operator", Keyword = "keyword", Exception = "keyword",
    PreProc = "orange", Include = "keyword", Define = "keyword", Type = "type",
    StorageClass = "keyword", Structure = "type", Typedef = "type", Special = "cyan",
    Delimiter = "punctuation", SpecialComment = "comment", Underlined = "blue",
    ["@comment"] = "comment", ["@string"] = "string", ["@number"] = "number",
    ["@boolean"] = "number", ["@constant"] = "number", ["@variable"] = "variable",
    ["@variable.parameter"] = "cyan", ["@variable.member"] = "cyan",
    ["@function"] = "function", ["@function.call"] = "purple", ["@function.method"] = "function",
    ["@keyword"] = "keyword", ["@type"] = "type", ["@type.builtin"] = "purple",
    ["@operator"] = "operator", ["@punctuation"] = "punctuation", ["@tag"] = "keyword",
    ["@tag.attribute"] = "purple", ["@module"] = "variable",
    ["@lsp.type.variable"] = "variable", ["@lsp.type.parameter"] = "cyan",
    ["@lsp.type.property"] = "cyan", ["@lsp.type.function"] = "function",
    ["@lsp.type.method"] = "function", ["@lsp.type.class"] = "type",
    ["@lsp.type.interface"] = "type", ["@lsp.type.enum"] = "type",
    ["@markup.heading"] = "accent", ["@markup.link"] = "blue", ["@markup.raw"] = "string",
  }) do
    hl(group, p[role], nil, { bold = role == "keyword" })
  end
  for suffix, color in pairs({ Error = p.red, Warn = p.yellow, Info = p.blue, Hint = p.cyan }) do
    hl("Diagnostic" .. suffix, color)
    hl("DiagnosticUnderline" .. suffix, nil, nil, { undercurl = true, sp = color })
  end
  hl("DiffAdd", p.green, p.surface)
  hl("DiffDelete", p.red, p.surface)
  hl("DiffChange", p.blue, p.surface)
  hl("DiffText", p.foreground, p.selection)
  hl("GitSignsAdd", p.green)
  hl("GitSignsChange", p.blue)
  hl("GitSignsDelete", p.red)
  local ansi = { mode == "dark" and "#242429" or "#26262b", p.red, p.green, p.yellow,
    p.blue, p.purple, p.cyan, "#d0d0d8", p.muted, p.red, p.green, p.yellow,
    p.blue, p.purple, p.cyan, mode == "dark" and "#ffffff" or "#ededf0" }
  for i, color in ipairs(ansi) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
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
  -- Native terminal appearance notifications vary inside multiplexers. On macOS
  -- query the system asynchronously every five seconds, without a global daemon.
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
  vim.api.nvim_create_autocmd("FocusGained", { group = group, callback = function() refresh(false) end })
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
