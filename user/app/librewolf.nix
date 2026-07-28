{ lib, userSettings, ... }: {
  programs.librewolf = {
    enable = true;
    profiles = lib.listToAttrs (
      lib.imap0 (i: name: {
        inherit name;
        value = {
          id = i;
          isDefault = i == 0;
        };
      }) userSettings.browserProfiles
    );
  };
}
