return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },

    opts = {
      interactions = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        cmd = {
          adapter = 'openai',
        },
      },

      adapters = {
        http = {
          openai = function()
            return require('codecompanion.adapters').extend('openai', {
              env = {
                api_key = 'NVIM_OPENAI_API_KEY',
              },
              schema = {
                model = {
                  default = 'gpt-5',
                },
              },
            })
          end,
        },
      },

      display = {
        chat = {
          window = {
            layout = 'vertical',
            position = 'right',
            width = 0.35,
          },
        },
      },
    },

    keys = {
      { '<leader>ac', '<cmd>CodeCompanionChat Toggle<CR>', mode = 'n', desc = 'AI Chat Toggle' },
      { '<leader>ac', '<cmd>CodeCompanionChat Add<CR>', mode = 'v', desc = 'Send Selection To Chat' },

      { '<leader>ai', '<cmd>CodeCompanion<CR>', mode = { 'n', 'v' }, desc = 'Inline AI Prompt' },

      { '<leader>ae', '<cmd>CodeCompanion /explain<CR>', mode = 'v', desc = 'Explain Code' },
      { '<leader>af', '<cmd>CodeCompanion /fix<CR>', mode = 'v', desc = 'Fix Code' },
      { '<leader>at', '<cmd>CodeCompanion /tests<CR>', mode = 'v', desc = 'Generate Tests' },
    },
  },
}
