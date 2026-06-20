return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- 설치할 LSP 서버 (TypeScript + Bun + Svelte 스택)
      local servers = {
        'ts_ls',                 -- TypeScript / JavaScript
        'svelte',                -- Svelte
        'eslint',                -- ESLint
        'tailwindcss',           -- Tailwind CSS
        'cssls',                 -- CSS
        'html',                  -- HTML
        'jsonls',                -- JSON
        'emmet_language_server', -- Emmet (html/svelte/jsx)
      }

      require('mason-lspconfig').setup({ ensure_installed = servers })

      -- 모든 서버에 자동완성 capabilities 주입
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('*', { capabilities = capabilities })

      -- Svelte: .ts 파일이 바뀌면 svelte 서버에 알려 타입 갱신
      vim.lsp.config('svelte', {
        on_attach = function(client)
          vim.api.nvim_create_autocmd('BufWritePost', {
            pattern = { '*.js', '*.ts' },
            group = vim.api.nvim_create_augroup('svelte_ts_watch', { clear = true }),
            callback = function(ctx)
              client:notify('$/onDidChangeTsOrJsFile', { uri = vim.uri_from_fname(ctx.file) })
            end,
          })
        end,
      })

      -- LSP가 버퍼에 붙을 때 단축키 설정
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
        callback = function(ev)
          local map = function(keys, fn, desc)
            vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = 'LSP: ' .. desc })
          end
          map('gd', vim.lsp.buf.definition, 'Goto definition')
          map('gD', vim.lsp.buf.declaration, 'Goto declaration')
          map('gr', vim.lsp.buf.references, 'References')
          map('gi', vim.lsp.buf.implementation, 'Goto implementation')
          map('K', vim.lsp.buf.hover, 'Hover docs')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
          map('<leader>td', vim.lsp.buf.type_definition, 'Type definition')
          map('[d', function() vim.diagnostic.jump({ count = -1 }) end, 'Prev diagnostic')
          map(']d', function() vim.diagnostic.jump({ count = 1 }) end, 'Next diagnostic')
          map('<leader>dl', vim.diagnostic.open_float, 'Line diagnostics')
        end,
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = 'rounded' },
        signs = true,
      })
    end,
  },
}
