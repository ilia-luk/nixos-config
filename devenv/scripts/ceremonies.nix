# Core wrapper ceremonies: keeping the wrapper in sync and populated.
{ ... }:
{
  scripts = {
    env-sync.exec = ''
      set -e
      echo ">> syncing wrapper against dotfiles..."
      nix flake update dotfiles nixpkgs-unstable
      git add flake.lock
      echo ">> lock updated; direnv reloads on next prompt (or: direnv reload)"
    '';

    repo-clone.exec = ''
      set -e
      : "''${PROJECT_REPO_URL:?PROJECT_REPO_URL not set}"
      : "''${PROJECT_NAME:?PROJECT_NAME not set}"
      if [ -d "$PROJECT_NAME" ]; then echo ">> $PROJECT_NAME already cloned"
      else git clone "$PROJECT_REPO_URL" "$PROJECT_NAME"; fi
    '';
  };
}
