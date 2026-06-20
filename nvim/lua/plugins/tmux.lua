return {
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Tmux/win left' },
      { '<c-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Tmux/win down' },
      { '<c-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Tmux/win up' },
      { '<c-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Tmux/win right' },
    },
  },
}
