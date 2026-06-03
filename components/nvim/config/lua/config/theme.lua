local M = {}

local function read_palette()
  local path = vim.fn.expand("~/.config/theme/palette.toml")
  local lines = vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}
  local colors = {}
  local in_colors = false

  for _, line in ipairs(lines) do
    if line:match("^%s*%[colors%]%s*$") then
      in_colors = true
    elseif line:match("^%s*%[.*%]%s*$") then
      in_colors = false
    elseif in_colors then
      local key, value = line:match('^%s*([%w_]+)%s*=%s*"([^"]*)"%s*$')
      if key and value then
        colors[key] = value
      end
    end
  end

  return colors
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function is_light(hex)
  local r, g, b = hex_to_rgb(hex)
  if not (r and g and b) then
    return false
  end
  return (0.299 * r + 0.587 * g + 0.114 * b) > 150
end

function M.apply()
  local c = read_palette()
  for _, key in ipairs({ "bg", "surface", "text", "dim", "accent", "accent_alt", "edge", "shadow", "neutral" }) do
    if not c[key] or c[key] == "" then
      return
    end
  end

  vim.o.background = is_light(c.bg) and "light" or "dark"
  vim.g.colors_name = "dots"

  local set = vim.api.nvim_set_hl
  set(0, "Normal", { fg = c.text, bg = c.bg })
  set(0, "NormalFloat", { fg = c.text, bg = c.surface })
  set(0, "FloatBorder", { fg = c.edge, bg = c.surface })
  set(0, "CursorLine", { bg = c.surface })
  set(0, "CursorLineNr", { fg = c.accent, bold = true })
  set(0, "LineNr", { fg = c.dim })
  set(0, "Visual", { bg = c.edge })
  set(0, "Search", { fg = c.bg, bg = c.accent })
  set(0, "IncSearch", { fg = c.bg, bg = c.accent_alt })
  set(0, "StatusLine", { fg = c.text, bg = c.surface })
  set(0, "StatusLineNC", { fg = c.dim, bg = c.surface })
  set(0, "WinSeparator", { fg = c.edge })
  set(0, "Pmenu", { fg = c.text, bg = c.surface })
  set(0, "PmenuSel", { fg = c.bg, bg = c.accent })
  set(0, "Comment", { fg = c.dim, italic = true })
  set(0, "Constant", { fg = c.accent_alt })
  set(0, "Identifier", { fg = c.text })
  set(0, "Statement", { fg = c.accent })
  set(0, "PreProc", { fg = c.accent_alt })
  set(0, "Type", { fg = c.neutral })
  set(0, "Special", { fg = c.accent })
  set(0, "Error", { fg = c.accent_alt, bold = true })
end

return M
