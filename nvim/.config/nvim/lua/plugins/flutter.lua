return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    require('flutter-tools').setup {
      debugger = {
        enabled = true,
      },
      flutter_path = '/bin/dart',
      default_run_args = { flutter = { '--web-browser-flag "--disable-web-security"' } },
    }
  end,
}
