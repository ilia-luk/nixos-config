{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "wrapper-init";
      runtimeInputs = [
        pkgs.git
        pkgs.gnused
      ];
      text = ''
        set -euo pipefail
        if [ $# -ne 2 ]; then
          echo "usage: wrapper-init <project-name> <repo-url>" >&2
          echo "  e.g.: wrapper-init accountant git@github.com:Domusnetwork/accountant.git" >&2
          exit 1
        fi
        name="$1"; url="$2"
        if [ -e "$name" ]; then
          echo "wrapper-init: '$name' already exists here" >&2
          exit 1
        fi

        mkdir "$name" && cd "$name"
        nix flake init -t ~/.dotfiles#wrapper

        sed -i "s|projectRepoUrl = \"git@github.com:CHANGEME/CHANGEME.git\"|projectRepoUrl = \"$url\"|" flake.nix
        sed -i "s|projectName = \"CHANGEME\"|projectName = \"$name\"|" flake.nix
        sed -i "s|^CHANGEME\*/|$name*/|" .gitignore

        git init -q && git add -A
        direnv allow

        echo ""
        echo "wrapper '$name' initialized. Next:"
        echo "  cd $name"
        echo "  repo-clone"
        echo "  dev-up"
      '';
    })
  ];
}
