{
  pkgs,
  userSettings,
  ...
}: {
  home.packages = with pkgs; [ 
    gh
    git
    git-credential-oauth
  ];
  
  programs.gh = {
   enable = true;
   # settings = {
   #   git_protocol = "ssh";
   # };
   gitCredentialHelper = {
     enable = false;
   };
  };

  programs.git = {
    enable = true;
    userName = userSettings.ghUsername;
    userEmail = userSettings.email;
    extraConfig = {
      # credential = {
      #   "https://github.com".username = userSettings.ghUsername;
      #   credentialStore = "cache";
      # };
      init.defaultBranch = "main";
      safe.directory = [
        ("/home/" + userSettings.username + "/.dotfiles")
        ("/home/" + userSettings.username + "/.dotfiles/.git")
      ];
    };
  };

  programs.git-credential-oauth = {
    enable = true;
  };
}
