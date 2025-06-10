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
  programs.starship.enableNushellIntegration = true;
  programs.starship.settings = {
    format = "[┌─$git_branch$git_status$git_commit$git_state$git_metrics$fill─> ](bold green)$character$cmd_duration$time
[│](bold green) $directory$rust$nodejs$bun$python$conda$package
[└──>](bold green) ";
    scan_timeout = 10;
    add_newline = true;
    command_timeout = 1000;
    fill = {
      symbol = "─";
      style = "bold green";
    };
    character = {
      success_symbol = "[✓ ](green)";
      error_symbol = "[ ](red)";
    };
    directory = {
      format = "[$path]($style)[$read_only]($read_only_style) ";
      home_symbol = "󰋞 ~";
      read_only = "  ";
      read_only_style = "197";
      style = "bold blue";
      truncation_symbol = "...";
      fish_style_pwd_dir_length = 8;
    };
    package = {
      format = " | [$symbol$version]($style) ";
      symbol = "📦 ";
      version_format = "v$raw";
      style = "bold 208";
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
    git_commit = {
      commit_hash_length = 4;
      tag_symbol = "🔖 ";
    };
     hostname = {
      ssh_only = false;
      format = "@ [$hostname](bold yellow) ";
      disabled = false;
    };
    username = {
      style_user = "white";
      style_root = "white";
      format = "[$user]($style) ";
      disabled = false;
      show_always = true;
    };
    sudo = {
      style = "bold green";
      symbol = "👩‍💻 ";
      disabled = false;
    };
    rust = {
      format = "| [🦀 $version](red bold)";
    };
    python = {
      symbol = "| 👾 ";
      pyenv_version_name = true;
    };
    conda = {
      format = "| [$symbol$environment](dimmed green) ";
    };
    nodejs = {
      format = "| [🤖 $version](bold green) ";
    };
    bun = {
      format = "| [🍔 $version](bold green) ";
    };
    direnv = {
      disabled = false;
    };
    time = {
      disabled = false;
      format = "[\\[ $time \\]]($style)";
      style = "bold yellow";
      time_format = "%T";
      utc_time_offset = "local";
    };
    cmd_duration = {
      min_time = 500;
      format = "[\\[ $duration \\]](bold cyan) | ";
    };
    shell = {
      disabled = false;
      nu_indicator = "❯";
      unknown_indicator = "❯";
      format = "[$indicator]($style) ";
      style = "bold green";
    };
  };
}
