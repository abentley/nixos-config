{
  # Bootloader.
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "0";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "skinny"; # Define your hostname.

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}
