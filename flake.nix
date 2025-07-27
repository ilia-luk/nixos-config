{
  description = "Flake of Domusnetwork";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, nixpkgs-unstable, nixvim, sops-nix, stylix, ... }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nexus"; # hostname
        profile =
          "personal"; # select a profile defined from my profiles directory
        timezone = "Asia/Bangkok"; # select timezone
        locale = "en_US.UTF-8"; # select locale
        bootMode = "uefi"; # uefi or bios
        bootMountPath =
          "/boot"; # mount path for efi boot partition; only used for uefi boot mode
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "ilia"; # username
        ghUsername = "ilia-luk";
        name = "Ilia"; # name/identifier
        avatar = builtins.path {
          path = ./misc/avatar.png;
          name = "my-awesome-avatar";
        };
        lockOverlay = builtins.path {
          path = ./misc/lock_overlay.png;
          name = "my-awesome-overlay";
        };
        email =
          "ilia@domusnetwork.io"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
        theme =
          "catppuccin-mocha"; # selcted theme from my themes directory (./themes/)
        wm =
          "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm
        wmType = "wayland"; # window manager type (hyprland or x11) translator
        browser =
          "firefox"; # Default browser; must select one from ./user/app/browser/
        term = "kitty"; # Default terminal command;
        font = "Fira Code"; # Selected font
        fontPkg = pkgs.nerd-fonts.fira-code; # Font package
        editor = "nvim"; # Default editor;
        defaultRoamDir =
          "Personal.p"; # Default org roam directory relative to ~/Org
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor = if (editor == "emacsclient") then
          "emacsclient -c -a 'emacs'"
        else
          (if ((editor == "vim") || (editor == "nvim")
            || (editor == "nano")) then
            "exec " + term + " -e " + editor
          else
            editor);
      };

      # ---------- PKGS --------- #
      pkgs-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = systemSettings.system;
          config = pkgs-config;
        };
      };
      pkgs = import nixpkgs {
        system = systemSettings.system;
        config = pkgs-config;
        overlays = [ overlay-unstable ];
      };

      # ---------- LIB ---------- #
      lib = nixpkgs.lib;

      # ------ HOME MANAGER ----- #
      home-manager = inputs.home-manager;

      # -------- SYSTEMS -------- #
      # Systems that can run tests:
      # supportedSystems = ["aarch64-linux" "i686-linux" "x86_64-linux"];

      # Function to generate a set based on supported systems:
      # forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

      # Attribute set of nixpkgs for each system:
      # nixpkgsFor = forAllSystems (system: import inputs.nixpkgs {inherit system;});

    in {
      nixosConfigurations = {
        nexus = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ overlay-unstable ];
              nixpkgs.config = pkgs-config;
            })
            (./. + "/profiles" + ("/" + systemSettings.profile)
              + "/configuration.nix")
          ];
          specialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      homeConfigurations = {
        ilia = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ overlay-unstable ];
              nixpkgs.config = pkgs-config;
            })
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
          ];
          extraSpecialArgs = {
            # pass config variables from above
            inherit systemSettings;
            inherit userSettings;
            inherit inputs;
          };
        };
      };

      # packages = forAllSystems (system: {
      #   let pkgs = nixpkgsFor.${system};
      #   in {
      #     default = self.packages.${system}.install;
      #     install = pkgs.writeShellApplication {
      #       name = "install";
      #       runtimeInputs = with pkgs; [ git ];
      #       text = ''${./install.sh} "$@"'';
      #     };
      #   }
      #  });

      #  apps = forAllSystems (system: {
      #    default = self.apps.${system}.install;
      #    install = {
      #      type = "app";
      #      program = "${self.packages.${system}.install}/bin/install";
      #    };
      #  });
    };
}
