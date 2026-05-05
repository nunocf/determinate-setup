_: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      save = 20000;
      size = 20000;
      share = true;
      append = true;
    };

    shellAliases = {
      ls = "ls --color=auto -F";
      la = "ls -la";
      ".." = "cd ..";
      "nix-switch" = "cd ~/.config/nix && nix flake check && sudo darwin-rebuild switch --flake ~/.config/nix";
    };

    initContent = ''
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --border=rounded --preview-window=right,60%,border-left --color=fg:#d3c6aa,bg:-1,hl:#a7c080,fg+:#d3c6aa,bg+:#2f383e,hl+:#83c092,info:#7fbbb3,prompt:#e69875,pointer:#e67e80,marker:#dbbc7f,spinner:#a7c080,header:#7a8478,border:#7a8478,gutter:-1'

      export OPENAI_API_KEY="$(security find-generic-password -a "$USER" -s openai-api-key -w)"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$fill$cmd_duration$line_break$character";
      fill.symbol = " ";
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
        vimcmd_symbol = "[Ν](bold blue)";
      };
      directory = {
        style = "bold blue";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
      };
      git_branch = {
        symbol = " ";
        style = "bold green";
      };
      git_status = {
        style = "yellow";
      };
      cmd_duration = {
        min_time = 500;
        style = "italic bright-black";
        format = "[$duration]($style)";
      };
    };
  };
}
