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
        key = "g";
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
