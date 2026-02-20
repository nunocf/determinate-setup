{
  sections = [
    {section = "header";}
    {
      section = "keys";
      gap = 1;
      padding = 1;
    }
  ];

  preset = {
    keys = [
      {
        action = "Telescope find_files";
        desc = " Find File";
        icon = " ";
        key = "f";
      }
      {
        action = "Telescope live_grep";
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
