return {
  -- 컬러스킴 (VSCode Dark+ 재현)
  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('vscode').setup({
        style = 'dark',
        -- 배경 + 기본 전경색만 TokyoNight(night)에서 가져옴 (나머지는 vscode 그대로)
        color_overrides = {
          vscBack = '#1a1b26',  -- TokyoNight night 배경
          vscFront = '#c0caf5', -- TokyoNight night 전경(살짝 파란 흰색)
        },
      })
      vim.cmd.colorscheme('vscode')

      -- 색 보정: (1) 잔여 아이보리(#D4D4D4) → 파란 흰색,
      --          (2) neo-tree 들여쓰기 가이드를 TokyoNight 톤으로
      local IVORY, TN_FG = '#d4d4d4', tonumber('c0caf5', 16)
      local TN_INDENT = tonumber('3b4261', 16)  -- TokyoNight fg_gutter
      local TN_BG_DARK = tonumber('16161e', 16) -- TokyoNight night 사이드바(bg_dark)
      local function fixups()
        for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
          if def.fg and ('#%06x'):format(def.fg) == IVORY then
            def.fg = TN_FG
            vim.api.nvim_set_hl(0, name, def)
          end
        end
        vim.api.nvim_set_hl(0, 'NeoTreeIndentMarker', { fg = TN_INDENT })
        vim.api.nvim_set_hl(0, 'NeoTreeExpander', { fg = TN_INDENT })
        -- 트리를 에디터보다 한 톤 어둡게
        vim.api.nvim_set_hl(0, 'NeoTreeNormal', { fg = TN_FG, bg = TN_BG_DARK })
        vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { fg = TN_FG, bg = TN_BG_DARK })
        vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { fg = TN_BG_DARK, bg = TN_BG_DARK })
      end
      fixups()
      vim.api.nvim_create_autocmd('ColorScheme', { pattern = 'vscode', callback = fixups })
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
