# Worktrunk guard: worktrees belong to the client repo, not the wrapper repo.
{ pkgs, ... }:
{
  scripts = {
    # Shadows worktrunk's binary on PATH in wrapper shells; blocks every
    # invocation whose git toplevel is the wrapper root (incl. the interactive
    # picker, which can create worktrees from its TUI).
    wt.exec = ''
      if [ "$(git rev-parse --show-toplevel 2>/dev/null)" = "$DEVENV_ROOT" ]; then
        echo "wt guard: this is the WRAPPER repo — cd into the project directory (the cloned client repo) first." >&2
        echo "  (escape hatch for debris cleanup: ${pkgs.unstable.worktrunk}/bin/wt)" >&2
        exit 1
      fi
      exec ${pkgs.unstable.worktrunk}/bin/wt "$@"
    '';
  };
}
