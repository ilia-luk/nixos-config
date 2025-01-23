{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    emacs
  ];
  
  programs.emacs = {
   enable = true;
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
    };
  };
}
