{
  config,
  pkgs,
  userSettings,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/" + userSettings.username;

  programs.home-manager.enable = true;

  imports = [
    ../../user/style/stylix.nix
    ../../user/app/git.nix
    ../../user/app/kitty.nix
    ../../user/app/yazi.nix
    ../../user/app/bat.nix
    ../../user/app/waybar.nix
    ../../user/app/fuzzel.nix
    ../../user/app/mako.nix
    ../../user/app/lazygit.nix
    ../../user/app/starship.nix
    ../../user/app/tmux.nix
    ../../user/app/zellij.nix
    ../../user/app/hyprpaper.nix
    # ../../user/app/nixvim/nixvim.nix
    ../../user/app/neovim/neovim.nix
    ../../user/app/thunderbird.nix
    ../../user/app/doom-emacs/doom.nix
    #../../user/hardware/bluetooth.nix
    #../../user/lang/cc.nix
    #../../user/lang/haskell.nix
    ../../user/shell/sh.nix
    ../../user/shell/direnv.nix
    ../../user/shell/devenv.nix
    ../../user/wm/hyprland.nix
  ];

  # Leave this unchanged for compatibility purposes
  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    zsh
    firefox
    vlc
    libreoffice-fresh
    discord
    slack
    _1password-gui
    unstable.qbittorrent
    postman
    figma-linux
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };
}
