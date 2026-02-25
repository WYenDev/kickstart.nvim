return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      -- See Configuration section for options
    },

    keys = {
      { '<leader>co', '<cmd>CopilotChatOpen<cr>', desc = 'CopilotChat Open' },
      { '<leader>ct', '<cmd>CopilotChatToggle<cr>', desc = 'CopilotChat Toggle' },
    },
  },
}
