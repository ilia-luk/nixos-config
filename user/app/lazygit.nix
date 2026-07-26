{ pkgs, config, ... }:
with config.lib.stylix.colors;
{
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
        activeBorderColor = [
          "#${base0E}"
          "bold"
        ];
        inactiveBorderColor = [ "#${base19}" ];
        optionsTextColor = [ "#${base0D}" ];
        selectedLineBgColor = [ "#${base02}" ];
        cherryPickedCommitBgColor = [ "#${base03}" ];
        cherryPickedCommitFgColor = [ "#${base0E}" ];
        unstagedChangesColor = [ "#${base08}" ];
        defaultFgColor = [ "#${base05}" ];
        searchingActiveBorderColor = [
          "#${base0A}"
          "bold"
        ];
      };
      nerdFontsVersion = "3";
      authorColors = {
        "*" = "#${base07}";
      };
    };
  };
}
