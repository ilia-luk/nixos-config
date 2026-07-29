# Shared devenv module for client project wrappers.
# Imported at runtime by each wrapper's flake as
#   "${inputs.dotfiles}/user/devenv/wrapper-base.nix"
# so ceremony improvements ship to all wrappers via `env-sync`.

{
  pkgs,
  lib,
  config,
  ...
}:
{
  scripts = {
    env-sync.exec = ''
      set -e
      echo ">> syncing wrapper against dotfiles..."
      nix flake update dotfiles
      git add flake.lock
      echo ">> lock updated; direnv will reload on next prompt (or run: direnv reload)"
    '';

    repo-clone.exec = ''
      set -e
      : "''${PROJECT_REPO_URL:?PROJECT_REPO_URL not set (define it in the wrapper env)}"
      : "''${PROJECT_NAME:?PROJECT_NAME not set (define it in the wrapper env)}"
      if [ -d "$PROJECT_NAME" ]; then
        echo ">> $PROJECT_NAME already cloned"
      else
        git clone "$PROJECT_REPO_URL" "$PROJECT_NAME"
      fi
    '';
  };
}
