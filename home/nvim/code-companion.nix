{lib, ...}: let
  mkLuaInline = lib.generators.mkLuaInline;
in {
  enable = true;

  setupOpts = {
    opts = {
      log_level = "ERROR";
      language = "English";
    };

    display = {
      chat = {
        start_in_insert_mode = true;
        show_settings = true;
        show_token_count = true;
      };

      diff = {
        enabled = true;
        provider = "inline";
        close_chat_at = 160;
      };

      inline.layout = "vertical";
    };

    adapters = mkLuaInline ''
      {
        acp = {
          opts = {
            show_presets = false,
          },
          codex = function()
              return require("codecompanion.adapters").extend("codex", {
                defaults = {
                  auth_method = "chatgpt",
                  session_config_options = {
                    model = "gpt-5.4",
                  },
                },
            })
          end,
        },
        http = {
          openai_responses = function()
            return require("codecompanion.adapters").extend("openai_responses", {
              env = {
                api_key = "OPENAI_API_KEY",
              },
              schema = {
                model = {
                  default = "gpt-5.4-nano",
                },
              },
            })
          end,
        },
      }
    '';

    interactions = {
      chat.adapter = {
        name = "codex";
        model = "gpt-5.4";
      };

      # ACP adapters are for chat sessions. Inline edits use an HTTP adapter.
      inline = {
        adapter = {
          name = "openai_responses";
          model = "gpt-5.4-nano";
        };

        keymaps = {
          accept_change.n = "gda";
          reject_change.n = "gdr";
        };
      };
    };
  };
}
