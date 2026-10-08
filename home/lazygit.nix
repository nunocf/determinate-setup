{config, ...}: {
  home.file.".config/lazygit/config.yml".text = ''
    gui:
      border: rounded
      theme:
        selectedLineBgColor:
          - '#374145'
        selectedRangeBgColor:
          - '#374145'
        inactiveBorderColor:
          - '#7a8478'
        activeBorderColor:
          - '#a7c080'
        optionsTextColor:
          - '#dbbc7f'
        cherryPickedCommitBgColor:
          - '#2f383e'
        cherryPickedCommitFgColor:
          - '#a7c080'
        markedBaseCommitBgColor:
          - '#2f383e'
        markedBaseCommitFgColor:
          - '#dbbc7f'
        unstagedChangesColor:
          - '#e67e80'
        defaultFgColor:
          - '#d3c6aa'
        searchingActiveBorderColor:
          - '#e69875'

      authorColors:
        '*': '#d3c6aa'

      branchColorPatterns:
        '.*': '#dbbc7f'

    git:
      pagers:
        - colorArg: always
          pager: delta --dark --paging=never --side-by-side --line-numbers
  '';
  home.file."Library/Application Support/lazygit/config.yml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/lazygit/config.yml";
}
