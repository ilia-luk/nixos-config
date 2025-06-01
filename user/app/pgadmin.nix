{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [ 
    pgadmin 
  ];
  
  services.pgadmin = {
   enable = true;
  };
}
