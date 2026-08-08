{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  # NVidia 1070 GTX support
  nixpkgs.config.cudaCapabilities = [ "6.1" ];
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    # package = pkgs.ollama-vulkan;
    # Pre-fetch models on service start (optional)
    loadModels = [
      "llama3.2:3b"
      "qwen2.5-coder:7b"
    ];
    # For network access:
    # host = "0.0.0.0";
    # port = 11434;
    # openFirewall = true;
  };

  # Optional: expose client tools in system profile
  environment.systemPackages = [
    pkgs.ollama
    pkgs.aider-chat
  ];
}
