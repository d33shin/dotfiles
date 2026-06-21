vim.g.mapleader = ' '

-- replaces selected text without losing what you yanked
vim.keymap.set('x', 'p', [["_dP]], { desc = 'Paste over selection without losing yanked text' })

-- delete text without saving it to any register
vim.keymap.set({ 'n', 'v' }, '<leader>d', [['_d]], { desc = 'Delete without yanking' })

vim.keymap.set('i', 'jk', '<Esc>')

-- move cursor in insert mode with ctrl+hjkl
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')

-- save file
vim.keymap.set('n', '<leader>s', '<cmd>w<cr>', { desc = 'Save file' })
