return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false, -- main branch does not support lazy-loading
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({
        'typescript', 'tsx', 'javascript', 'svelte',
        'css', 'html', 'json', 'yaml',
        'markdown', 'markdown_inline', 'toml',
        'lua', 'vim', 'vimdoc', 'bash', 'dockerfile',
      })

      -- filetype → parser mappings for filetypes whose name differs from the parser
      -- (main has no separate jsonc parser; the json parser handles it)
      vim.treesitter.language.register('bash', { 'sh' })
      vim.treesitter.language.register('json', { 'jsonc' })

      -- main branch enables nothing automatically — start highlight + indent per buffer.
      -- injections work out of the box here (no more master/0.12 heredoc crash).
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
