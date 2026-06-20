return {
  -- 컬러스킴
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup({ theme = 'wave' })
      vim.cmd.colorscheme('kanagawa')
    end,
  },

  -- 상태줄
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'kanagawa',
        globalstatus = true,
        section_separators = '',
        component_separators = '|',
      },
    },
  },
}
