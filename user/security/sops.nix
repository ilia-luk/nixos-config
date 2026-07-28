{ inputs, userSettings, ... }: {
  imports = with inputs; [ sops-nix.homeManagerModules.sops ];

  # Enable sops
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    validateSopsFiles = false;

    age = {
      # This is the username/dev key and needs to have been copied to this location on the host
      keyFile = "/home/${userSettings.username}/.config/sops/age/keys.txt";
    };

    # secrets will be output to /run/secrets
    # e.g /run/secrets/msmtp-password
    # secrets required for user creation are handled in respective ./users/<username>.nix files
    # because they will be output to /run/secrets-for-users and only when the user is assigned to a host.
    secrets = {
      "private_keys/${userSettings.username}" = {
        path = "/home/${userSettings.username}/.ssh/id_ed25519";
      };
      ilia-password = { };
      gh-oauth = { };
      openai-api-key = { };
      claude-api-key = { };
      kimi-api-key = { };
    };
  };
}
