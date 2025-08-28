return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim',
  },
  config = function()
    print 'configuring flutter tools'
    require('flutter-tools').setup {
      debugger = {
        enabled = true,
      },
      default_run_args = { flutter = { '--web-browser-flag "--disable-web-security"' } },
    }
  end,
}
