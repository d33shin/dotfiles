-- lazy.nvim 부트스트랩 (없으면 자동 설치)
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'lazy.nvim 클론 실패:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
    }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = { { import = 'plugins' } },
  install = { colorscheme = { 'kanagawa', 'habamax' } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
