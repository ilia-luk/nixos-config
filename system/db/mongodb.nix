{ pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    unstable.mongodb-7_0
    mongodb-tools
    robo3t
    mongodb-compass
    lsb-release # For mongodb-memory-server
    openssl
    openssl_1_1
    lzlib
    libGL
    libuuid
    curlFull
  ];

  # Global variables for mongodb-memory-server
  environment.variables = {
    MONGOMS_PLATFORM = "linux";
    MONGOMS_DISTRO = "ubuntu-22.04";
    MONGOMS_VERSION = "7.0.16";
    MONGOMS_DOWNLOAD_URL =
      "https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-7.0.16.tgz";
    LD_LIBRARY_PATH = "${
        lib.makeLibraryPath (with pkgs; [
          stdenv.cc.cc
          # openssl
          openssl_1_1 # https://discourse.nixos.org/t/how-to-fix-library-is-missing-or-cannot-be-opened-libcrypto-so-1-1/30730, https://github.com/nodkz/mongodb-memory-server/issues/782
          lzlib # related https://github.com/NixOS/nix/issues/1550
          libGL
          libuuid
          curlFull
        ])
      }:$LD_LIBRARY_PATH";
    # NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [ unstable.stdenv.cc.cc unstable.openssl_1_1 unstable.curlFull ]);
    # NIX_LD = builtins.readFile "${pkgs.unstable.stdenv.cc}/nix-support/dynamic-linker";  
  };

  services.mongodb = {
    package = pkgs.unstable.mongodb-7_0;
    enable = true;
    extraConfig = ''
      operationProfiling.mode: all
      systemLog.quiet: false
    '';
  };
}
