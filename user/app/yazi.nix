{
  config,
  pkgs,
  ...
}:
with config.lib.stylix.colors; {
  home.packages = [pkgs.yazi];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      show_hidden = true;
      sort_dir_first = true;
      sort_by = "size";
      linemode = "size";
    };
    theme = {
      manager = {
        cwd = {fg = "#${base0C}";};

        # Hovered
        hovered = {
          fg = "#${base05}";
          bg = "#${base02}";
        };
        preview_hovered = {underline = true;};

        # Find
        find_keyword = {
          fg = "#${base0A}";
          italic = true;
        };
        find_position = {
          fg = "#${base09}";
          bg = "reset";
          italic = true;
        };

        # Marker
        marker_selected = {
          fg = "#${base0C}";
          bg = "#${base0C}";
        };
        marker_copied = {
          fg = "#${base0A}";
          bg = "#${base0A}";
        };
        marker_cut = {
          fg = "#${base08}";
          bg = "#${base08}";
        };

        # Tab
        tab_active = {
          fg = "#${base06}";
          bg = "#${base00}";
        };
        tab_inactive = {
          fg = "#${base04}";
          bg = "#${base00}";
        };
        tab_width = 1;

        # Border
        border_symbol = "│";
        border_style = {fg = "#${base03}";};
      };
      status = {
        separator_open = "";
        separator_close = "";
        separator_style = {
          fg = "#${base03}";
          bg = "#${base03}";
        };

        # Mode
        mode_normal = {
          fg = "#${base00}";
          bg = "#${base0E}";
          bold = true;
        };
        mode_select = {
          fg = "#${base04}";
          bg = "#${base0C}";
          bold = true;
        };
        mode_unset = {
          fg = "#${base04}";
          bg = "#${base08}";
          bold = true;
        };

        # Progress
        progress_label = {
          fg = "#${base04}";
          bold = true;
        };
        progress_normal = {
          fg = "#${base00}";
          bg = "#${base00}";
        };
        progress_error = {
          fg = "#${base08}";
          bg = "#${base00}";
        };

        # Permissions
        permissions_t = {fg = "#${base0D}";};
        permissions_r = {fg = "#${base0A}";};
        permissions_w = {fg = "#${base08}";};
        permissions_x = {fg = "#${base0C}";};
        permissions_s = {fg = "#${base04}";};
      };
      input = {
        border = {fg = "#${base03}";};
        title = {};
        value = {};
        selected = {reversed = true;};
      };
      select = {
        border = {fg = "#${base03}";};
        active = {fg = "#${base09}";};
        inactive = {};
      };
      tasks = {
        border = {fg = "#${base03}";};
        title = {};
        hovered = {underline = true;};
      };
      which = {
        mask = {bg = "#${base03}";};
        cand = {fg = "#${base0C}";};
        rest = {fg = "#${base03}";};
        desc = {fg = "#${base09}";};
        separator = "  ";
        separator_style = {fg = "#${base03}";};
      };
      help = {
        on = {fg = "#${base09}";};
        exec = {fg = "#${base0C}";};
        desc = {fg = "#${base03}";};
        hovered = {
          bg = "#${base03}";
          bold = true;
        };
        footer = {
          fg = "#${base00}";
          bg = "#${base04}";
        };
      };
      filetype = {
        rules = [
          # Images
          {
            mime = "image/*";
            fg = "#${base0C}";
          }

          # Videos
          {
            mime = "video/*";
            fg = "#${base0A}";
          }
          {
            mime = "audio/*";
            fg = "#${base0A}";
          }

          # Archives
          {
            mime = "application/zip";
            fg = "#${base09}";
          }
          {
            mime = "application/gzip";
            fg = "#${base09}";
          }
          {
            mime = "application/x-tar";
            fg = "#${base09}";
          }
          {
            mime = "application/x-bzip";
            fg = "#${base09}";
          }
          {
            mime = "application/x-bzip2";
            fg = "#${base09}";
          }
          {
            mime = "application/x-7z-compressed";
            fg = "#${base09}";
          }
          {
            mime = "application/x-rar";
            fg = "#${base09}";
          }

          # Fallback
          {
            name = "*";
            fg = "#${base05}";
          }
          {
            name = "*/";
            fg = "#${base0D}";
          }
        ];
      };
    };
  };

  home.file.".config/yazi/init.lua".text = ''
       function Status:name()
         local h = cx.active.current.hovered
         if not h then
         	return ui.Span("")
         end

         local linked = ""
         if h.link_to ~= nil then
    linked = " -> " .. tostring(h.link_to)
         end

         return ui.Span(" " .. h.name .. linked)
       end

       function Status:owner()
         local h = cx.active.current.hovered
         if h == nil or ya.target_family() ~= "unix" then
         	return ui.Line {}
         end

         return ui.Line {
         	ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
         	ui.Span(":"),
         	ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
         	ui.Span(" "),
         }
       end

       function Status:position()
         local cursor = cx.active.current.cursor
         local length = #cx.active.current.files

         local style = self.style()
         return ui.Line {
         	ui.Span(string.format(" %2d/%-2d ", cursor + 1, length)):style(style),
         	ui.Span(THEME.status.separator_close):fg(style.bg),
         }
       end

       function Status:render(area)
         self.area = area

         local left = ui.Line { self:mode(), self:size(), self:name() }
         local right = ui.Line { self:owner(), self:permissions(), self:percentage(), self:position() }
         return {
         	ui.Paragraph(area, { left }),
         	ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
         	table.unpack(Progress:render(area, right:width())),
         }
       end
  '';
}
