-- Base config
vim.opt.termguicolors = true
vim.opt.updatetime = 1000
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.history = 25
vim.opt.showcmd = true
vim.opt.incsearch = true
vim.opt.wildmenu = true
vim.opt.hlsearch = true
vim.opt.ruler = true
vim.opt.hidden = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.list = true
vim.opt.listchars = { nbsp = '.', trail = '.', tab = '>-', space = '.' }
vim.opt.textwidth = 100
vim.opt.wrap = true
vim.opt.foldmethod = 'indent'
vim.opt.title = true
vim.opt.spell = true
vim.opt.spelllang = { 'es', 'en' }
vim.opt.spellsuggest = { 'best', 9 }
vim.opt.spelloptions = 'camel'

-- Plug config
local Plug = vim.fn['plug#']
vim.call('plug#begin', '~/.config/nvim/plugged_minimal')

Plug('jiangmiao/auto-pairs')
Plug('tek/vim-fieldtrip')
Plug('AndrewRadev/sideways.vim')
Plug('kana/vim-submode')
Plug('junegunn/vim-easy-align')
Plug('jeetsukumaran/vim-indentwise')
Plug('dense-analysis/ale')
Plug('tpope/vim-commentary')
Plug('leafgarland/typescript-vim')
Plug('vim-airline/vim-airline')
Plug('zivyangll/git-blame.vim')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('m-demare/hlargs.nvim')
Plug('uga-rosa/ccc.nvim')
Plug('RRethy/base16-nvim')
Plug('neovim/nvim-lspconfig')

vim.call('plug#end')

--- Base16 config
local palette = require('palette/nvim-colors');

require('base16-colorscheme').setup({
   base00 = palette.dark[600], -- background
   base01 = palette.dark[500], -- no idea
   base02 = palette.dark[400], -- no idea
   base03 = palette.green[600], -- comments
   base04 = palette.dark[300], -- line numbers
   base05 = palette.light[100], -- text
   base06 = palette.light[200], -- no idea
   base07 = palette.light[600], -- no idea
   base08 = palette.orange[300], -- return, etc
   base09 = palette.orange[200], -- index, booleans, etc
   base0A = palette.violet[200], -- const, async, search results, etc
   base0B = palette.green[300], -- strings
   base0C = palette.green[600],
   base0D = palette.blue[400], -- parentheses, functions, etc
   base0E = palette.violet[200], -- if, and, function, local, etc
   base0F = palette.violet[400], -- commas, dots
})

-- Treesitter
vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "markdown",
    "markdown_inline",
    "tsx",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { "markdown" },
  },
}

-- CCC config
require("ccc").setup({
  highlighter = {
    auto_enable = true,
    lsp = false,
    update_insert = true,
  },
  highlight_mode = "virtual",
  virtual_pos = "inline-right",
  virtual_symbol = " ❉ ",
  output_format = "hex",
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "TextChangedP", "CursorHold", "CursorMoved" }, {
  pattern = "*",
  callback = function()
    local ok, ccc = pcall(require, "ccc")
    if ok and ccc and ccc.highlighter and ccc.highlighter.update then
      ccc.highlighter:update()
    end
  end,
})

-- Popups
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      border = "single",
      max_width = 80,
      max_height = 10,
    })
  end,
})

-- LSP
local lspconfig = require('lspconfig')

lspconfig.ts_ls.setup {
  root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", ".git"),
  on_attach = function(_, bufnr)
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover, opts)
  end,
}

vim.o.winborder = 'single'

-- Key map
vim.g.mapleader = " "
vim.api.nvim_set_keymap('n', '<leader>-', 'o<Esc>0i- [ ]', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>_', 'o<Esc>0i<Tab>- [ ]', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>c', '0f[lrx', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>u', '0f[lr<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>p', '0f[lr-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', '', { noremap = true, silent = true }) -- Asigna la función deseada

-- EasyAlign map
vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})
vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})

-- ALE config
vim.g.ale_linters = {
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  astro = { 'eslint' },
  markdown = { 'languagetool' },
  text = { 'languagetool' },
  json = { 'jq' },
}

vim.g.ale_fixers = {
  javascript = { 'prettier' },
  typescript = { 'prettier' },
  astro = { 'prettier' },
  json = { 'jq' },
}

vim.g.ale_fix_on_save = 1
vim.g.ale_languagetool_language = 'es-AR,en-US'
vim.g.ale_echo_cursor = 1
vim.g.ale_hover_cursor = 1
vim.g.ale_set_hover = 1
vim.g.ale_virtualtext_cursor = 0

-- ALE map
vim.api.nvim_set_keymap('n', '<Leader>an', ':ALENext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ap', ':ALEPrevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ad', ':ALEDetail<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>at', ':ALEToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>af', ':ALEFix<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>as', ':ALEFixSuggest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>al', ':ALELint<CR>', { noremap = true, silent = true })

-- Spell map
vim.api.nvim_set_keymap('n', '<Leader>sn', ']s', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sp', '[s', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sf', 'z=', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sg', 'zg', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>sw', 'zw', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>su', 'zu', { noremap = true, silent = true })

-- Git map
vim.api.nvim_set_keymap('n', '<Leader>b', ':<C-u>call gitblame#echo()<CR>', { noremap = true, silent = true })

-- CCC map
vim.keymap.set("n", "<leader>cp", ":CccPick<CR>", { desc = "Open CCC Picker" })
vim.keymap.set("n", "<leader>cc", ":CccConvert<CR>", { desc = "Convert color" })
vim.keymap.set("n", "<leader>ce", ":CccHighlighterEnable<CR>", { desc = "Enable CCC" })
vim.keymap.set("n", "<leader>cd", ":CccHighlighterDisable<CR>", { desc = "Disable CCC" })
vim.keymap.set("n", "<leader>ct", ":CccHighlighterToggle<CR>", { desc = "Toggle CCC" })
vim.keymap.set("n", "<leader>cr", function()
  vim.cmd("CccHighlighterToggle")
  vim.cmd("CccHighlighterToggle")
end, { desc = "Refresh CCC highlight" })

-- Navigation map
vim.keymap.set("n", "<leader>re", ":e %:h", { desc = "Open relative path" })
vim.keymap.set("n", "<leader>rv", ":vs %:h", { desc = "Open relative path with vsplit" })
vim.keymap.set("n", "<leader>rs", ":split %:h", { desc = "Open relative path with split" })
