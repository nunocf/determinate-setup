{
  lib,
  machineProfile ? {},
  ...
}: let
  inherit (lib.generators) mkLuaInline;
  isWorkMacbook = (machineProfile.homeConfigurationName or "") == "work-macbook";
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
        close_chat_at = 0;
      };

      inline.layout = "vertical";
    };

    adapters = mkLuaInline (
      if isWorkMacbook
      then ''
        {
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                api_key = "CLAUDE_CODE_OAUTH_TOKEN",
              },
            })
          end,
        }
      ''
      else ''
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
      ''
    );
    extensions = {
      history = {
        enabled = true;
        opts = {
          keymap = "gh";
          auto_save = true;
          expiration_days = 0;
          save_on_close = true;
        };
      };
    };

    strategies.chat.tools.vectorcode = {
      description = "Search the codebase for semantically similar code chunks";
      opts.num_query = 10;
    };

    interactions = {
      chat.adapter =
        if isWorkMacbook
        then {name = "claude_code";}
        else {
          name = "codex";
          model = "gpt-5.4";
        };

      # ACP adapters are for chat sessions. Inline edits use an HTTP adapter.
      inline = {
        adapter =
          if isWorkMacbook
          then {
            name = "claude_code";
          }
          else {
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
