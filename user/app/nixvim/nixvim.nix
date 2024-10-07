{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./config
  ];

  programs.nixvim.enable = true;
  programs.nixvim = {
    defaultEditor = true;
  };
}
