{
  description = "Flake of Domusnetwork";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      # this line is optional, prevents downloading two versions of nixpkgs but disables cache
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      stylix,
      ...
    }:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nexus";
        # select a profile defined from my profiles directory
        profile = "personal";
        timezone = "Asia/Bangkok";
        locale = "en_US.UTF-8";
        # uefi or bios
        bootMode = "uefi";
        # mount path for efi boot partition; only used for uefi boot mode
        bootMountPath = "/boot";
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "ilia";
        location = "Bangkok";
        ghUsername = "ilia-luk";
        name = "Ilia";
        avatar = builtins.path {
          path = ./misc/avatar.png;
          name = "my-awesome-avatar";
        };
        lockOverlay = builtins.path {
          path = ./misc/lock_overlay.png;
          name = "my-awesome-overlay";
        };
        # email (used for certain configurations)
        email = "ilia@domusnetwork.io";
        # absolute path of the local repo
        dotfilesDir = "~/.dotfiles";
        # selcted theme from my themes directory (./themes/)
        theme = "catppuccin-mocha";
        # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm
        wm = "hyprland";
        # window manager type (hyprland or x11) translator
        wmType = "wayland";
        # Default browser; must select one from ./user/app/browser/
        browser = "firefox";
        # Default terminal command;
        term = "kitty";
        font = "FiraCode Nerd Font";
        fontPkg = pkgs.nerd-fonts.fira-code;
        editor = "nvim";
        # Default org roam directory relative to ~/Org
        defaultRoamDir = "Personal.p";
        # editor spawning translator
        # generates a command that can be used to spawn editor inside a gui
        # EDITOR and TERM session variables must be set in home.nix or other module
        # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
        spawnEditor =
          if (editor == "emacsclient") then
            "emacsclient -c -a 'emacs'"
          else
            (
              if ((editor == "vim") || (editor == "nvim") || (editor == "nano")) then
                "exec " + term + " -e " + editor
              else
                editor
            );
      };

      # ---------- PKGS --------- #
      pkgs-config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
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

    in
    {
      nixosConfigurations = {
        nexus = lib.nixosSystem {
          system = systemSettings.system;
          modules = [
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ overlay-unstable ];
              nixpkgs.config = pkgs-config;
            })
            (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
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
    };
}
