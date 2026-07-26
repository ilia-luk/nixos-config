{ config, pkgs, ... }:
with config.lib.stylix.colors;
{
  home.packages = [ pkgs.yazi ];

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "y";
    settings = {
      log = {
        enabled = false;
      };
      mgr = {
        show_hidden = true;
        sort_by = "mtime";
        sort_dir_first = true;
        sort_reverse = true;
      };
    };
    theme = {
      mgr = {
        cwd = {
          fg = "#${base0C}";
        };
        # Hovered
        hovered = {
          fg = "#${base05}";
          bg = "#${base02}";
        };
        preview_hovered = {
          underline = true;
        };
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
        # Border
        border_symbol = "│";
        border_style = {
          fg = "#${base03}";
        };
      };
      tabs = {
        active = {
          fg = "#${base06}";
          bg = "#${base04}";
        };
        inactive = {
          fg = "#${base04}";
          bg = "#${base00}";
        };
        sep_inner = {
          open = "";
          close = "";
        };
        sep_outer = {
          open = "";
          close = "";
        };
      };
      mode = {
        normal_main = {
          fg = "#${base00}";
          bg = "#${base0E}";
          bold = true;
        };
        normal_alt = {
          fg = "#${base0E}";
          bg = "#${base03}";
        };
        select_main = {
          fg = "#${base04}";
          bg = "#${base0C}";
          bold = true;
        };
        select_alt = {
          fg = "#${base04}";
          bg = "#${base0B}";
        };
        unset_main = {
          fg = "#${base04}";
          bg = "#${base08}";
          bold = true;
        };
      };
      status = {
        overall = {
          fg = "#${base07}";
          bg = "#${base00}";
        };
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
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
        perm_type = {
          fg = "#${base0D}";
        };
        perm_read = {
          fg = "#${base0A}";
        };
        perm_write = {
          fg = "#${base08}";
        };
        perm_exec = {
          fg = "#${base0C}";
        };
        perm_sep = {
          fg = "#${base04}";
        };
      };
      which = {
        mask = {
          bg = "#${base03}";
        };
        cand = {
          fg = "#${base0C}";
        };
        rest = {
          fg = "#${base03}";
        };
        desc = {
          fg = "#${base09}";
        };
        separator = "  ";
        separator_style = {
          fg = "#${base03}";
        };
      };
      input = {
        border = {
          fg = "#${base03}";
        };
        title = { };
        value = { };
        selected = {
          reversed = true;
        };
      };
      cmp = {
        border = {
          fg = "#${base03}";
        };
        active = {
          fg = "#${base09}";
        };
        inactive = { };
      };
      tasks = {
        border = {
          fg = "#${base03}";
        };
        title = { };
        hovered = {
          underline = true;
        };
      };
      help = {
        on = {
          fg = "#${base09}";
        };
        run = {
          fg = "#${base0C}";
        };
        desc = {
          fg = "#${base03}";
        };
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
            url = "*";
            fg = "#${base05}";
          }
          {
            url = "*/";
            fg = "#${base0D}";
          }
        ];
      };
    };
    initLua = ''
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
         --
         -- function Status:position()
         --   local cursor = cx.active.current.cursor
         --   local length = #cx.active.current.files
         --
         --   local style = self.style()
         --   return ui.Line {
         --   	ui.Span(string.format(" %2d/%-2d ", cursor + 1, length)):style(style),
         --   	ui.Span(THEME.status.separator_close):fg(style.bg),
         --   }
         -- end
         
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
  };
}
