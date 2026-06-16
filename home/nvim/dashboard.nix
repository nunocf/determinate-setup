{pkgs}: let
  paneSpaces = pkgs.lib.concatStrings (builtins.genList (_: " ") 60);
  paneSpacer = pkgs.lib.concatStringsSep "\n" (builtins.genList (_: paneSpaces) 10);

  pokemonDashboard = pkgs.writeShellScript "pokemon-dashboard" ''
    ${pkgs.pokemon-colorscripts}/bin/pokemon-colorscripts -r | ${pkgs.perl}/bin/perl -CS -Mutf8 -e '
      binmode(STDIN, ":encoding(UTF-8)");
      binmode(STDOUT, ":encoding(UTF-8)");

      my $target_height = 31;
      my @lines = <STDIN>;
      chomp @lines;

      my $name = shift(@lines) // "";
      my $display_name = $name;
      $display_name =~ s/^(\s*)(\S)/$1 . uc($2)/e;

      sub plain {
        my ($line) = @_;
        $line =~ s/\e\[[0-9;:]*[A-Za-z]//g;
        return $line;
      }

      my $min_left;
      my $max_right = -1;

      for my $line (@lines) {
        my $clean = plain($line);
        next unless $clean =~ /\S/;

        $clean =~ /^(\s*)/;
        my $left = length($1);

        $clean =~ /(.*\S)/;
        my $right = length($1) - 1;

        $min_left = $left if !defined($min_left) || $left < $min_left;
        $max_right = $right if $right > $max_right;
      }

      $min_left = 0 if !defined($min_left);
      $max_right = $min_left if $max_right < $min_left;

      my $sprite_width = $max_right - $min_left + 1;
      my $name_width = length(plain($display_name));
      my $name_pad = $min_left + int(($sprite_width - $name_width) / 2);
      $name_pad = 0 if $name_pad < 0;

      my $content_height = scalar(@lines) + 2;
      my $top_pad = int(($target_height - $content_height) / 2);
      $top_pad = 0 if $top_pad < 0;

      print "\n" x $top_pad;
      print join("\n", @lines), "\n\n";
      print " " x $name_pad, $display_name, "\n";
    '

    exec ${pkgs.coreutils}/bin/sleep 86400
  '';
in {
  sections = [
    {
      text = paneSpacer;
    }
    {
      section = "keys";
      gap = 1;
    }
    {
      text = paneSpacer;
    }
    {
      section = "terminal";
      cmd = "${pokemonDashboard}";
      random = 10;
      pane = 2;
      indent = 20;
      width = 60;
      height = 31;
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
