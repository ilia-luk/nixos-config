{ inputs, config, ... }: {
  imports = [ inputs.pi.homeModules.default ];

  programs.pi.coding-agent = {
    enable = true;
    settings = {
      enableInstallTelemetry = false;
      defaultProjectTrust = "ask";
    };
    environment = {
      KIMI_API_KEY.file = config.sops.secrets."kimi-api-key".path; # Kimi-when-it-matters, metered
      # ANTHROPIC_API_KEY.file = config.sops.secrets."claude-api-key".path;  # Claude-when-it-matters, metered
      # OPENAI_API_KEY.file = config.sops.secrets."openai-api-key".path;  # Codex-when-it-matters, metered
    };
  };
}
