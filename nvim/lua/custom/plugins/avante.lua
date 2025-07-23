return {
  "yetone/avante.nvim",
  build = "make",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "openai",
    providers = {
      openai = {
        endpoint = "https://ai-proxy-json-api.us1.staging.dog/v1/",
        extra_headers = {
          ["x-datadog-org-id"] = "2",
          ["x-datadog-source"] = "debug",
          ["x-datadog-user-id"] = "eloy.toro@datadoghq.com"
        },
        extra_request_body = {
          temperature = 0, -- adjust if needed
        },
        model = "gpt-4o",  -- your desired model (or use gpt-4o, etc.)
        timeout = 30000,   -- timeout in milliseconds
        max_tokens = 4096,
        -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      },
    }
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "stevearc/dressing.nvim",        -- for input provider dressing
    "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
  },
}
