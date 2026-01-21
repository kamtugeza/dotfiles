return {
  'neovim/nvim-lspconfig',
  config = function()

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp', { clear = true }),
      callback = function(event)
        vim.keymap.set('n', 'grn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
        vim.keymap.set('n', 'gra', vim.lsp.buf.code_action, { desc = '[G]oto Code [A]ction' })
        vim.keymap.set('n', 'grr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
        vim.keymap.set('n', 'gri', require('telescope.builtin').lsp_implementations, { desc = '[G]oto [I]mplementation' })
        vim.keymap.set('n', 'grd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
        vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
        vim.keymap.set('n', 'gO', require('telescope.builtin').lsp_document_symbols, { desc = 'Open Document Symbols' })
        vim.keymap.set('n', 'gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = 'Open Workspace Symbols' })
        vim.keymap.set('n', 'grt', require('telescope.builtin').lsp_type_definitions, { desc = '[G]oto [T]ype Definition' })

        -- Diagnostics
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror message' })
        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix' })
      end,

    })

    vim.lsp.enable('bashls')
    vim.lsp.enable('codebook')
    vim.lsp.enable('cssls')
    vim.lsp.enable('html')
    vim.lsp.enable('jsonls')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('vtsls')
    vim.lsp.enable('zls')

  end
}
