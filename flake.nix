{
  description = "Flake of Domusnetwork";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix/release-24.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    emacs-pin-nixpkgs.url = "nixpkgs/f72123158996b8d4449de481897d855bc47c7bf6";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "emacs-pin-nixpkgs";
    # nix-straight.url = "github:librephoenix/nix-straight.el/pgtk-patch";
    # nix-straight.flake = false;
    # nix-doom-emacs.inputs.nix-straight.follows = "nix-straight";
    eaf = {
      url = "github:emacs-eaf/emacs-application-framework";
      flake = false;
    };
    eaf-browser = {
      url = "github:emacs-eaf/eaf-browser";
      flake = false;
    };
    org-nursery = {
      url = "github:chrisbarrett/nursery";
      flake = false;
    };
    org-yaap = {
      url = "gitlab:tygrdev/org-yaap";
      flake = false;
    };
    org-side-tree = {
      url = "github:localauthor/org-side-tree";
      flake = false;
    };
    org-timeblock = {
      url = "github:ichernyshovvv/org-timeblock";
      flake = false;
    };
    org-krita = {
      url = "github:librephoenix/org-krita";
      flake = false;
    };
    org-xournalpp = {
      url = "gitlab:vherrmann/org-xournalpp";
      flake = false;
    };
    org-sliced-images = {
      url = "github:jcfk/org-sliced-images";
      flake = false;
    };
    magit-file-icons = {
      url = "github:librephoenix/magit-file-icons/abstract-icon-getters-compat";
      flake = false;
    };
    phscroll = {
      url = "github:misohena/phscroll";
      flake = false;
    };
    mini-frame = {
      url = "github:muffinmad/emacs-mini-frame";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixvim,
    sops-nix,
    ...
  }: let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "nexus"; # hostname
      profile = "personal"; # select a profile defined from my profiles directory
      timezone = "Asia/Bangkok"; # select timezone
      locale = "en_US.UTF-8"; # select locale
      bootMode = "uefi"; # uefi or bios
      bootMountPath = "/boot"; # mount path for efi boot partition; only used for uefi boot mode
    };

    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "ilia"; # username
      name = "Ilia"; # name/identifier
      email = "ilia@domusnetwork.io"; # email (used for certain configurations)
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      theme = "catppuccin-mocha"; # selcted theme from my themes directory (./themes/)
      wm = "hyprland"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm
      wmType = "wayland"; # window manager type (hyprland or x11) translator
      browser = "firefox"; # Default browser; must select one from ./user/app/browser/
      term = "kitty"; # Default terminal command;
      font = "Inconsolata"; # Selected font
      fontPkg = pkgs.inconsolata; # Font package
      editor = "nvim"; # Default editor;
      defaultRoamDir = "Personal.p"; # Default org roam directory relative to ~/Org
      # editor spawning translator
      # generates a command that can be used to spawn editor inside a gui
      # EDITOR and TERM session variables must be set in home.nix or other module
      # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
      spawnEditor = if (editor == "emacsclient") then
                      "emacsclient -c -a 'emacs'"
                    else
                      (if
                        (
                          (editor == "vim")
                          || (editor == "nvim")
                          || (editor == "nano")
                        )
                      then "exec " + term + " -e " + editor
                      else editor);
    };

    # ---------- PKGS --------- #
    overlay-unstable = final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
          permittedInsecurePackages = [ "openssl-1.1.1w" ];
        };
      };
    };
    overlay-emacs = final: prev: {
      emacs = import inputs.emacs-pin-nixpkgs {
        system = systemSettings.system;
      };
    };
    pkgs = import inputs.nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
        permittedInsecurePackages = [ "openssl-1.1.1w" ];
      };
      overlays = [ overlay-unstable overlay-emacs];
    };

    # ---------- LIB ---------- #
    lib = inputs.nixpkgs.lib;

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
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")
        ];
        specialArgs = {
          # pass config variables from above
          inherit pkgs;
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
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-unstable ]; })
          (./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")
        ];
        extraSpecialArgs = {
          # pass config variables from above
          inherit pkgs;
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
