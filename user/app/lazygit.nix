{ pkgs, config, ... }:
with config.lib.stylix.colors; {
  home.packages = with pkgs; [ lazygit ];

  programs.lazygit.enable = true;
  # programs.lazygit.enableNushellIntegration = true;
  programs.lazygit.settings = {
    os = {
      editPreset = "nvim-remote";
      edit = ''
        if ($env.NVIM? | is-empty) { 
          nvim {{filename}} 
        } else { 
          nvim --server $env.NVIM --remote-send (['<C-\><C-n>:q<CR>:tabedit ' {{filename}} '<CR>'] | str join)
        }
      '';
      editAtLine = ''
        if ($env.NVIM? | is-empty) { 
          nvim +{{line}} {{filename}} 
        } else { 
          nvim --server $env.NVIM --remote-send (['<C-\><C-n>:q<CR>:tabedit ' {{filename}} '<CR>:{{line}}<CR>'] | str join)
        }
      '';
    };
    gui = {
      theme = {
        activeBorderColor = [ "#${base06}" "bold" ];
        inactiveBorderColor = [ "#${base04}" ];
        optionsTextColor = [ "#${base0D}" ];
        selectedLineBgColor = [ "#${base02}" ];
        cherryPickedCommitBgColor = [ "#${base03}" ];
        cherryPickedCommitFgColor = [ "#${base06}" ];
        unstagedChangesColor = [ "#${base0F}" ];
        defaultFgColor = [ "#${base05}" ];
        searchingActiveBorderColor = [ "#${base0A}" ];
      };
      nerdFontsVersion = "3";
      authorColors = { "*" = "#${base07}"; };
    };
  };
}
