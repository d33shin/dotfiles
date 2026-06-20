return {
  -- 컬러스킴
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({ style = 'night' })
      vim.cmd.colorscheme('tokyonight')
    end,
  },

  -- 상태줄
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'tokyonight',
        globalstatus = true,
        section_separators = '',
        component_separators = '|',
      },
    },
  },
}
