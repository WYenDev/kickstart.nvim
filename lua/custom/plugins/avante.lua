return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false, -- Required for Avante to load its UI and commands properly
  version = false,
  -- Safest build command for cross-platform compatibility
  build = vim.fn.has 'win32' == 1 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',

  ---@module 'avante'
  ---@type avante.Config
  opts = {
    instructions_file = 'avante.md',
    behaviour = {
      auto_apply_diff_after_generation = false,
      auto_approve_tool_permissions = false,
    },

    input = {
      provider = 'snacks',
    },
    provider = 'deepseek_chat',

    providers = {
      deepseek_chat = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        model = 'deepseek-chat',
        timeout = 30000,
        api_key_name = 'DEEPSEEK_API_KEY', -- FIXED: Dynamically loads the key to prevent nil errors
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192, -- FIXED: Adjusted to standard output limits
        },
      },
      deepseek_reasoner = {
        __inherited_from = 'openai',
        endpoint = 'https://api.deepseek.com',
        model = 'deepseek-reasoner',
        timeout = 30000,
        api_key_name = 'DEEPSEEK_API_KEY', -- FIXED: Dynamically loads the key
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
      },
      moonshot = {
        __inherited_from = 'openai',
        endpoint = 'https://api.moonshot.ai', -- FIXED: Removed /v1 since openai inheritance auto-appends paths
        model = 'kimi-k2-0711-preview',
        timeout = 30000,
        api_key_name = 'MOONSHOT_API_KEY', -- Best practice: load dynamically
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 8192,
        },
      },
    },
  },

  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- Optional dependencies
    'nvim-mini/mini.pick',
    'nvim-telescope/telescope.nvim',
    'hrsh7th/nvim-cmp',
    'ibhagwan/fzf-lua',
    'stevearc/dressing.nvim',
    'folke/snacks.nvim',
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    {
      -- Support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      -- Markdown rendering for Avante UI
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
