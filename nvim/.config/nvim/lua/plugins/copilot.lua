return {
  'zbirenbaum/copilot.lua',
  dependencies = {},
  config = function()
    require('copilot').setup {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
        },
      },
    }
  end,
}
