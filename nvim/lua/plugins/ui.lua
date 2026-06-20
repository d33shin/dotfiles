return {
  -- 컬러스킴 (VSCode Dark+ 재현)
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('vscode').setup({ style = 'dark' })
      vim.cmd.colorscheme('vscode')
    end,
  },

  -- 상태줄
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        section_separators = '',
        component_separators = '|',
      },
    },
  },
}
