# Agent notes — project wrapper

Context for the coding agent working in this wrapper.

- The actual client repository is cloned into the subdirectory named after the
  project (see `projectName` in flake.nix). Work happens there; this wrapper
  level holds the development environment only.
- Run project commands from inside the repo subdirectory, not the wrapper root.

## Project specifics

<!-- fill in as they emerge: build/test commands, conventions, gotchas -->
