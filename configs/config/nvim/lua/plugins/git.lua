return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function (bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Actions: Normal Mode
      local function diff_agains_last_commit()
        gitsigns.diffthis '@'
      end

      map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>hD', diff_agains_last_commit, { desc = 'git [D]iff against last commit' })

      -- Actions: Visual Mode
      local function reset_visual_hunk()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end

      local function stage_visual_hunk()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end

      map('v', '<leader>hr', reset_visual_hunk, { desc = 'git [r]eset hunk' })
      map('v', '<leader>hs', stage_visual_hunk, { desc = 'git [s]tage hunk' })

      -- Navigation
      local function nav_next_hunk()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end

      local function nav_prev_hunk()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end

      map('n', ']c', nav_next_hunk, { desc = 'Jump to next git [c]hange' })
      map('n', '[c', nav_prev_hunk, { desc = 'Jump to previous git [c]hange' })

      -- Toggles
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>tD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })

    end
  },
}
