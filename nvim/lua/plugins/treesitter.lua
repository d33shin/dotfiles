return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'typescript', 'tsx', 'javascript', 'svelte',
        'css', 'html', 'json', 'jsonc', 'yaml',
        'markdown', 'markdown_inline', 'toml',
        'lua', 'vim', 'vimdoc', 'bash', 'dockerfile',
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
