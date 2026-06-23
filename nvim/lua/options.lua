vim.g.netrw_banner = 0

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = true          -- 긴 줄을 다음 줄로 넘겨서 표시
vim.opt.linebreak = true     -- 단어 중간이 아니라 단어 경계에서 줄바꿈
vim.opt.breakindent = true   -- 줄바꿈된 줄도 들여쓰기 유지
vim.opt.smartindent = true
vim.opt.inccommand = 'split'

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.laststatus = 3

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
vim.opt.undofile = true

vim.opt.clipboard:append('unnamedplus')

-- GNOME Terminal은 OSC52를 지원하지 않으므로 wl-clipboard를 직접 호출
vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ['+'] = 'wl-copy',
    ['*'] = 'wl-copy --primary',
  },
  paste = {
    ['+'] = 'wl-paste --no-newline',
    ['*'] = 'wl-paste --no-newline --primary',
  },
  cache_enabled = true,
}
vim.opt.isfname:append('@-@')
vim.opt.guicursor = ''
vim.opt.scrolloff = 8

vim.opt.colorcolumn = '0'
vim.opt.signcolumn = 'yes'
vim.o.cmdheight = 0
vim.opt.termguicolors = true

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- bun.lock 은 JSONC(주석·trailing comma 허용)라 jsonc 로 인식 (jsonls 오탐 방지)
vim.filetype.add({
  filename = { ['bun.lock'] = 'jsonc' },
})
