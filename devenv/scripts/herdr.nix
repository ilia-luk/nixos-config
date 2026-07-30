# Herdr feature bundle: per-project sessions and their lifecycle.
{ ... }:
{
  scripts = {
    # Attach/create this project's own herdr session (never the default one).
    herd.exec = ''
      exec herdr --session "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}" "$@"
    '';

    # Stop + delete this project's herdr session for a clean start
    # (a detached server keeps pre-env-sync binaries alive until stopped).
    herd-reset.exec = ''
      set -e
      : "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}"
      herdr session stop "$PROJECT_NAME" --json >/dev/null 2>&1 || true
      herdr session delete "$PROJECT_NAME" --json >/dev/null 2>&1 || true
      echo ">> herdr session '$PROJECT_NAME' stopped and deleted — 'herd' starts fresh"
    '';

    # Is anything alive in this project's herdr session?
    herd-status.exec = ''
      : "''${PROJECT_NAME:?PROJECT_NAME not set (run inside a wrapper)}"
      if herdr --session "$PROJECT_NAME" workspace list 2>/dev/null; then
        exit 0
      else
        echo ">> herdr session '$PROJECT_NAME' is not running"
      fi
    '';
  };
}
