vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup {}

    vim.keymap.set('n', '<leader>t', ':NvimTreeFindFile<CR>', { desc = 'Open Tree on File', noremap = true })
    vim.keymap.set('n', '<leader>te', ':NvimTreeToggle<CR>', { desc = 'Open/Close Tree' })
  end,
}
