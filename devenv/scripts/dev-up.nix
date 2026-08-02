# dev-up: create-or-attach this project's zellij session with the standard
# five-tab layout (editor / services / agents / reviews / shell). Layout is
# generated per-wrapper so the editor tab opens inside the client repo.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  repoDir = config.env.PROJECT_NAME or "CHANGEME";
  layout = pkgs.writeText "wrapper-layout.kdl" ''
    layout {
        default_tab_template {
            pane size=1 borderless=true {
                plugin location="zellij:tab-bar"
            }
            children
            pane size=2 borderless=true {
                plugin location="zellij:status-bar"
            }
        }
        tab name="editor" focus=true cwd="${repoDir}" {
            pane split_direction="vertical" {
                pane command="nvim" size="55%" {
                    args "."
                }
                pane stacked=true {
                    pane command="pi"
                    pane
                }
            }
        }
        tab name="services" {
            pane
        }
        tab name="agents" {
            pane command="herd"
        }
        tab name="reviews" {
            pane command="gh-dash"
        }
        tab name="shell" {
            pane
        }
    }
  '';
in
{
  scripts.dev-up.exec = ''
    : "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}"
    if [ -n "''${ZELLIJ:-}" ]; then
      echo "dev-up: already inside a zellij session — run from a plain terminal" >&2
      exit 1
    fi
    if zellij list-sessions 2>/dev/null | grep -q "^$PROJECT_NAME\b\|^$PROJECT_NAME "; then
      exec zellij attach "$PROJECT_NAME"
    else
      exec zellij --session "$PROJECT_NAME" --new-session-with-layout ${layout}
    fi
  '';
}
