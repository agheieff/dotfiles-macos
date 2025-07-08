vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.showmode = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.expandtab = false
vim.opt.spell = true
vim.opt.timeoutlen = 300
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.shortmess:append('I')
vim.opt.scrolloff = 3
vim.opt.hlsearch = true

vim.cmd([[
augroup fourSpacesIndent
    autocmd!
    autocmd FileType html,xml,ui setlocal shiftwidth=4 tabstop=4 expandtab=false
    autocmd FileType haskell,cabal,nix,hamlet setlocal shiftwidth=4 tabstop=4 expandtab
augroup END
]])

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netew_altv = 1
vim.g.netrw_winsize = 24

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', 'w', 'k')
vim.keymap.set('n', 'a', 'h')
vim.keymap.set('n', 'r', 'j')
vim.keymap.set('n', 's', 'l')

vim.keymap.set('n', '<Leader>e', ':Lexplore<CR>', {noremap = true, silent = true})

vim.cmd([[
augroup CloseNetrwIfLast
  autocmd!
  autocmd BufEnter * if winnr('$') == 1 && &filetype == 'netrw' | q | endif
augroup END
]])

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 200,
    })
  end,
})

vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.cursorline = true

local colors = {
    bg = '#1a2233',
    bg_dark = '#141829',
    bg_highlight = '#2a3559',
    normal = '#c5d4ff',
    orange = '#d4976c',
    orange_dim = '#b37e5c',
    blue = '#65b1cd',
    blue_dark = '#507d99',
    comment = '#506176',
    selection = '#2e3c64',
    line_nr = '#506176',
    cursor_line_nr = '#65b1cd'
}

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local highlights = {
            -- Editor highlights
            { "Normal", { fg = colors.normal, bg = colors.bg } },
            { "NormalFloat", { fg = colors.normal, bg = colors.bg_dark } },
            { "ColorColumn", { bg = colors.bg_highlight } },
            { "CursorLine", { bg = colors.bg_highlight } },
            { "CursorLineNr", { fg = colors.cursor_line_nr, bold = true } },
            { "LineNr", { fg = colors.line_nr } },
            { "Comment", { fg = colors.comment, italic = true } },
            { "Visual", { bg = colors.selection } },

            { "Function", { fg = colors.blue } },
            { "String", { fg = colors.orange_dim } },
            { "Keyword", { fg = colors.blue, bold = true } },
            { "Identifier", { fg = colors.normal } },
            { "Statement", { fg = colors.blue } },
            { "Type", { fg = colors.blue_dark } },
            { "Special", { fg = colors.orange } },

            { "Pmenu", { fg = colors.normal, bg = colors.bg_dark } },
            { "PmenuSel", { fg = colors.normal, bg = colors.selection } },
            { "SignColumn", { bg = colors.bg } },
            { "StatusLine", { fg = colors.normal, bg = colors.bg_dark } },
            { "VertSplit", { fg = colors.bg_highlight, bg = colors.bg } },
        }

        for _, hi in ipairs(highlights) do
            vim.api.nvim_set_hl(0, hi[1], hi[2])
        end
    end
})

vim.cmd('colorscheme default')
