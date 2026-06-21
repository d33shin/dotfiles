return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
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
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- nvim-treesitter master(EOL)의 `set-lang-from-info-string!` directive가
      -- Neovim 0.11+ 의 새 match 형식(노드 → 노드 리스트)을 못 다뤄 크래시함.
      -- (증상: hover/마크다운 코드펜스에서 'attempt to call method range' 에러로 색 다 죽음)
      -- 동일 directive를 0.12 형식에 맞게 재등록해 덮어씀.
      vim.treesitter.query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local nodes = match[pred[2]]
        local node = type(nodes) == 'table' and nodes[#nodes] or nodes
        if not node then return end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata['injection.language'] = vim.filetype.match({ filename = 'a.' .. alias }) or alias
      end, { force = true })

      -- nvim-treesitter master(EOL)의 bash injection 쿼리가 Neovim 0.12 코어와 비호환.
      -- heredoc(<<EOF) 안 언어 주입 처리 중 nil 노드에서 'attempt to call method range'로
      -- 크래시 → 하이라이터(decoration provider) 죽어 전체 흰색. heredoc 내부 임베드
      -- 언어 색칠은 안 쓰므로 bash injection 쿼리를 비워 비활성화.
      vim.treesitter.query.set('bash', 'injections', '')
    end,
  },
}
