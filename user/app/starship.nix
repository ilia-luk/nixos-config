{
  pkgs,
  config,
  lib,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [
    starship
  ];

  programs.starship.enable = true;
  programs.starship.settings = {
    format = lib.concatStrings [
      "$git_branch"
      "$git_status"
      "$line_break"
      "$directory"
      "$character"
    ];
    scan_timeout = 10;
    add_newline = true;
    command_timeout = 1000;
    character = {
      success_symbol = "[](magenta)";
      error_symbol = "[](red)";
    };
    username = {
      style_user = "white";
      style_root = "white";
      format = "[$user]($style) ";
      disabled = false;
      show_always = true;
    };
    hostname = {
      ssh_only = false;
      format = "@ [$hostname](bold yellow) ";
      disabled = false;
    };
    directory = {
      home_symbol = "󰋞 ~";
      read_only_style = "197";
      read_only = "  ";
      style = "bold blue";
      format = "[$path]($style)[$read_only]($read_only_style) ";
    };
    git_branch = {
      symbol = " ";
      format = "[$symbol $branch]($style) ";
      style = "bold green";
    };
    git_status = {
      format = "[\($all_status$ahead_behind\)]($style) ";
      style = "bold cyan";
      conflicted = "🏳";
      up_to_date = " ";
      untracked = " ";
      ahead = "⇡\${count}";
      diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
      behind = "⇣\${count}";
      stashed = " ";
      modified = " ";
      staged = "[++\($count\)](green)";
      renamed = "襁 ";
      deleted = " ";
    };
  };
}
