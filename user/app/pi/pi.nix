{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  base = import ./base.nix {
    inherit pkgs lib;
    homeDir = config.home.homeDirectory;
  };
  piTheme = with config.lib.stylix.colors; {
    "$schema" =
      "https://raw.githubusercontent.com/earendil-works/pi/main/packages/coding-agent/src/modes/interactive/theme/theme-schema.json";
    name = "stylix";
    vars = {
      rosewater = "#${base06}";
      flamingo = "#${base0F}";
      pink = "#${base17}";
      mauve = "#${base0E}";
      red = "#${base08}";
      maroon = "#${base12}";
      peach = "#${base09}";
      yellow = "#${base0A}";
      green = "#${base0B}";
      teal = "#${base0C}";
      sky = "#${base15}";
      sapphire = "#${base16}";
      blue = "#${base0D}";
      lavender = "#${base07}";
      text = "#${base05}";
      subtext1 = "#${base18}";
      subtext0 = "#${base19}";
      overlay2 = "#${base24}";
      overlay1 = "#${base23}";
      overlay0 = "#${base22}";
      surface2 = "#${base04}";
      surface1 = "#${base03}";
      surface0 = "#${base02}";
      base = "#${base00}";
      mantle = "#${base01}";
      crust = "#${base11}";
      customMessageBg = "#${base01}"; # K3 used a bespoke tint; mantle keeps it distinct from userMessageBg and scheme-driven
      toolPendingBg = "#${base02}";
      toolSuccessBg = "#2f3b2c"; # green-tinted surface; no base16 slot — mocha-specific literal
      toolErrorBg = "#402b34"; # red-tinted surface; same caveat
    };
    colors = {
      accent = "mauve";
      border = "surface1";
      borderAccent = "mauve";
      borderMuted = "surface0";
      success = "green";
      error = "red";
      warning = "yellow";
      muted = "subtext0";
      dim = "overlay1";
      text = "text";
      thinkingText = "subtext1";
      selectedBg = "surface1";
      userMessageBg = "surface0";
      userMessageText = "text";
      customMessageBg = "customMessageBg";
      customMessageText = "text";
      customMessageLabel = "pink";
      toolPendingBg = "toolPendingBg";
      toolSuccessBg = "toolSuccessBg";
      toolErrorBg = "toolErrorBg";
      toolTitle = "text";
      toolOutput = "subtext1";
      mdHeading = "peach";
      mdLink = "blue";
      mdLinkUrl = "overlay1";
      mdCode = "peach";
      mdCodeBlock = "text";
      mdCodeBlockBorder = "surface2";
      mdQuote = "subtext1";
      mdQuoteBorder = "overlay1";
      mdHr = "surface2";
      mdListBullet = "mauve";
      toolDiffAdded = "green";
      toolDiffRemoved = "red";
      toolDiffContext = "subtext0";
      syntaxComment = "overlay1";
      syntaxKeyword = "mauve";
      syntaxFunction = "blue";
      syntaxVariable = "text";
      syntaxString = "green";
      syntaxNumber = "peach";
      syntaxType = "yellow";
      syntaxOperator = "sky";
      syntaxPunctuation = "subtext1";
      thinkingOff = "surface1";
      thinkingMinimal = "overlay0";
      thinkingLow = "sapphire";
      thinkingMedium = "blue";
      thinkingHigh = "mauve";
      thinkingXhigh = "pink";
      thinkingMax = "red";
      bashMode = "peach";
    };
    export = {
      pageBg = "base";
      cardBg = "mantle";
      infoBg = "surface0";
    };
  };
in
{
  imports = [ inputs.pi.homeModules.default ];

  home.file.".pi/agent/themes/stylix.json".text = builtins.toJSON piTheme;
  home.file.".pi/agent/skills/tuicr".source = "${pkgs.unstable.tuicr.src}/skills/tuicr";
  home.file.".pi/agent/AGENTS.md".source = ./AGENTS.md;
  home.file.".pi/agent/prompts".source = ./prompts;

  programs.pi.coding-agent = {
    enable = true;
    settings = base.settings;
    environment = base.environment;
    models = ./models.json;
    jail = {
      enable = true;
      permissions = base.jailPermissions [ ];
    };
  };
}
