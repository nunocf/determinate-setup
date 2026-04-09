{
  sections = [
    {
      section = "keys";
      gap = 1;
      padding = 1;
    }
  ];

  preset = {
    keys = [
      {
        action = ":lua Snacks.dashboard.pick('files')";
        desc = " Find File";
        icon = " ";
        key = "f";
      }
      {
        action = ":lua Snacks.dashboard.pick('live_grep')";
        desc = " Find Text";
        icon = " ";
        key = "s";
      }
      {
        action = ":lua Snacks.dashboard.pick('recent')";
        desc = " Recent Files";
        icon = " ";
        key = "r";
      }
      {
        action = ":lua Snacks.dashboard.pick('projects')";
        desc = " Projects";
        icon = " ";
        key = "p";
      }
      {
        action = ":SessionLoad";
        desc = " Restore Session";
        icon = " ";
        key = "l";
      }
      {
        action = ":qa";
        desc = " Quit";
        icon = " ";
        key = "q";
      }
    ];
  };
}
