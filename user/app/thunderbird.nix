{
  pkgs,
  userSettings,
  ...
}: {
  home.packages = [pkgs.thunderbird];
  programs.thunderbird.enable = true;
  programs.thunderbird.settings = {
    "privacy.donottrackheader.enabled" = true;
  };
  programs.thunderbird.profiles.${userSettings.username} = {
    isDefault = true;
    settings = {};
  };
}
