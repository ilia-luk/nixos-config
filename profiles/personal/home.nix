{
  config,
  pkgs,
  userSettings,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/style/stylix.nix
    ../../user/app/pi.nix
    ../../user/app/librewolf.nix
    ../../user/app/trash.nix
    ../../user/app/noctalia.nix
    ../../user/app/git.nix
    ../../user/app/kitty.nix
    ../../user/app/yazi.nix
    ../../user/app/bat.nix
    ../../user/app/neovim.nix
    ../../user/app/lazygit.nix
    ../../user/app/gh-dash.nix
    ../../user/app/starship.nix
    ../../user/app/tmux.nix
    ../../user/app/zellij.nix
    ../../user/app/carapace.nix
    ../../user/app/atuin.nix
    ../../user/app/zoxide.nix
    ../../user/app/feh.nix
    ../../user/app/thunderbird.nix
    ../../user/security/sops.nix
    ../../user/shell/sh.nix
    ../../user/shell/direnv.nix
    ../../user/shell/devenv.nix
    ../../user/wm/hyprland.nix
    ../../user/wm/hyprpaper.nix
    ../../user/wm/hyprlock.nix
    ../../user/wm/hypridle.nix
  ];

  # Leave this unchanged for compatibility purposes
  home.stateVersion = "24.05";

  # Applications that don't need special configurations
  home.packages = with pkgs; [
    firefox
    unstable.discord
    unstable.qbittorrent
    vlc
    libreoffice-fresh
    slack
    _1password-gui
    postman
    figma-linux
    blender
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # symlink to the Nix store copy.
    # # ".screenrc".source = dotfiles/screenrc;

    # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      DOTFILES = "${config.home.homeDirectory}/.dotfiles";
      ARCHIVE = "${config.home.homeDirectory}/Archive";
      VM = "${config.home.homeDirectory}/Machines";
      ORG = "${config.home.homeDirectory}/Org";
      PODCAST = "${config.home.homeDirectory}/Media/Podcasts";
      BOOK = "${config.home.homeDirectory}/Media/Books";
      PICTURES = "${config.home.homeDirectory}/Media/Pictures";
      VIDEOS = "${config.home.homeDirectory}/Media/Videos";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = [ "librewolf.desktop" ];
    "x-scheme-handler/https" = [ "librewolf.desktop" ];
    "text/html" = [ "librewolf.desktop" ];
  };
  xdg.configFile."uwsm/env".text = ''
    export MOZ_ENABLE_WAYLAND=0
  '';

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };
}
