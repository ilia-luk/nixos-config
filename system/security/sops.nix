{ inputs, pkgs, ... }: {
  imports = with inputs; [ sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [ age sops ];

  # Enable sops
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      # automatically import host SSH keys as age keys
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      # this will use an age key that is expected to already be in the system
      keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };

    # secrets will be output to /run/secrets
    # e.g /run/secrets/msmtp-password
    # secrets required for user creation are handled in respective ./users/<username>.nix files
    # because they will be output to /run/secrets-for-users and only when the user is assigned to a host.
    secrets = {
      ilia-password = { };
      ilia-nordtoken = { };
      gh-oauth = { };
      gh-access-token = { };
      openai-api-key = { };
    };
  };
}
