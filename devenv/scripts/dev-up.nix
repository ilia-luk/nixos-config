# dev-up: create-or-attach this project's zellij session using the shared
# "wrapper" layout (defined HM-side in user/app/zellij.nix, where the
# stylix/zjstatus theming lives). Launched from inside the client repo so
# the layout's relative cwds resolve: editor tabs = repo, others = wrapper.
{ ... }:
{
  scripts.dev-up.exec = ''
    : "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}"
    if [ "$PROJECT_NAME" = "CHANGEME" ]; then
      echo "dev-up: flake.nix still has CHANGEME placeholders — edit projectName/projectRepoUrl first" >&2
      exit 1
    fi
    if [ ! -d "$DEVENV_ROOT/$PROJECT_NAME" ]; then
      echo "dev-up: client repo '$PROJECT_NAME/' not found — run: repo-clone" >&2
      exit 1
    fi
    if [ -n "''${ZELLIJ:-}" ]; then
      echo "dev-up: already inside a zellij session — run from a plain terminal" >&2
      exit 1
    fi
    cd "$DEVENV_ROOT/$PROJECT_NAME"
    if zellij list-sessions 2>/dev/null | grep -q "^$PROJECT_NAME\b\|^$PROJECT_NAME "; then
      exec zellij attach "$PROJECT_NAME"
    else
      exec zellij --session "$PROJECT_NAME" --new-session-with-layout wrapper
    fi
  '';
}
