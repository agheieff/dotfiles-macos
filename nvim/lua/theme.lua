local M = {}

-- Define colors
local colors = {
    bg = "#1a1b26",
    fg = "#c0caf5",
    black = "#15161e",
    red = "#f7768e",
    green = "#9ece6a",
    yellow = "#e0af68",
    blue = "#7aa2f7",
    magenta = "#bb9af7",
    cyan = "#7dcfff",
    white = "#a9b1d6",
    orange = "#ff9e64",
    comment = "#565f89",
}

-- Function to set highlight
local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Set colorscheme
function M.set_theme()
    -- Set the background
    vim.opt.background = "dark"
    vim.opt.termguicolors = true

    -- Editor colors
    hi("Normal", { fg = colors.fg, bg = colors.bg })
    hi("NormalFloat", { fg = colors.fg, bg = colors.black })
    hi("Cursor", { fg = colors.bg, bg = colors.fg })
    hi("CursorLine", { bg = colors.black })
    hi("LineNr", { fg = colors.comment })
    hi("SignColumn", { bg = colors.bg })

    -- Syntax highlighting
    hi("Comment", { fg = colors.comment, italic = true })
    hi("Constant", { fg = colors.orange })
    hi("String", { fg = colors.green })
    hi("Character", { fg = colors.green })
    hi("Number", { fg = colors.orange })
    hi("Boolean", { fg = colors.orange })
    hi("Float", { fg = colors.orange })
    hi("Identifier", { fg = colors.fg })
    hi("Function", { fg = colors.blue })
    hi("Statement", { fg = colors.magenta })
    hi("Conditional", { fg = colors.magenta })
    hi("Repeat", { fg = colors.magenta })
    hi("Label", { fg = colors.magenta })
    hi("Operator", { fg = colors.blue })
    hi("Keyword", { fg = colors.magenta })
    hi("Exception", { fg = colors.magenta })
    hi("PreProc", { fg = colors.cyan })
    hi("Include", { fg = colors.cyan })
    hi("Define", { fg = colors.magenta })
    hi("Macro", { fg = colors.magenta })
    hi("PreCondit", { fg = colors.cyan })
    hi("Type", { fg = colors.blue })
    hi("StorageClass", { fg = colors.blue })
    hi("Structure", { fg = colors.blue })
    hi("Typedef", { fg = colors.blue })
    hi("Special", { fg = colors.yellow })
    hi("SpecialChar", { fg = colors.yellow })
    hi("Tag", { fg = colors.blue })
    hi("Delimiter", { fg = colors.fg })
    hi("SpecialComment", { fg = colors.comment })
    hi("Debug", { fg = colors.red })
    hi("Underlined", { fg = colors.cyan, underline = true })
    hi("Ignore", { fg = colors.comment })
    hi("Error", { fg = colors.red })
    hi("Todo", { fg = colors.yellow, bold = true })

    -- Interface highlights
    hi("StatusLine", { fg = colors.fg, bg = colors.black })
    hi("StatusLineNC", { fg = colors.comment, bg = colors.black })
    hi("TabLine", { fg = colors.comment, bg = colors.black })
    hi("TabLineFill", { fg = colors.comment, bg = colors.black })
    hi("TabLineSel", { fg = colors.fg, bg = colors.bg })
    hi("VertSplit", { fg = colors.black, bg = colors.black })
    hi("Visual", { bg = colors.comment })
    hi("VisualNOS", { bg = colors.comment })
    hi("Pmenu", { fg = colors.fg, bg = colors.black })
    hi("PmenuSel", { fg = colors.bg, bg = colors.blue })
    hi("PmenuSbar", { bg = colors.black })
    hi("PmenuThumb", { bg = colors.fg })
    hi("WildMenu", { fg = colors.bg, bg = colors.blue })
    hi("Question", { fg = colors.yellow })
    hi("WarningMsg", { fg = colors.red })
    hi("ErrorMsg", { fg = colors.red, bg = colors.bg })
    hi("SpecialKey", { fg = colors.comment })
    hi("Directory", { fg = colors.blue })
    hi("Title", { fg = colors.blue, bold = true })

    -- Diff highlighting
    hi("DiffAdd", { fg = colors.green, bg = colors.bg })
    hi("DiffChange", { fg = colors.yellow, bg = colors.bg })
    hi("DiffDelete", { fg = colors.red, bg = colors.bg })
    hi("DiffText", { fg = colors.blue, bg = colors.bg })

    -- Spelling
    hi("SpellBad", { undercurl = true, sp = colors.red })
    hi("SpellCap", { undercurl = true, sp = colors.yellow })
    hi("SpellRare", { undercurl = true, sp = colors.blue })
    hi("SpellLocal", { undercurl = true, sp = colors.cyan })
end

return M
