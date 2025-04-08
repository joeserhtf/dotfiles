return {
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      local function go_to_harpoon_file(dest)
        return function()
          harpoon:list():select(dest)
        end
      end

      vim.keymap.set('n', '<leader>fm', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<leader>fv', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set('n', '<leader>fj', go_to_harpoon_file(1))
      vim.keymap.set('n', '<leader>fk', go_to_harpoon_file(2))
      vim.keymap.set('n', '<leader>fl', go_to_harpoon_file(3))
      vim.keymap.set('n', '<leader>f;', go_to_harpoon_file(4))
    end,
  },
}
