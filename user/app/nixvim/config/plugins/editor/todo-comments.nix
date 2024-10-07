{config, ...}:
with config.lib.stylix.colors; {
  programs.nixvim.plugins.todo-comments = {
    enable = true;
    colors = {
      error = ["DiagnosticError" "ErrorMsg" "#${base08}"];
      warning = ["DiagnosticWarn" "WarningMsg" "#${base0A}"];
      info = ["DiagnosticInfo" "#${base0D}"];
      default = ["Identifier" "#${base07}"];
      test = ["Identifier" "#${base0E}"];
    };
  };
}
