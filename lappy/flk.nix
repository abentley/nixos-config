# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  self,
  nixpkgs,
  home-manager,
  ...
}:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../features/flake-enablement.nix
    ../features/grub.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    (
      { config, pkgs, ... }:

      {
        imports = [
          # Include the results of the hardware scan.
        ];

        # Bootloader.
        boot = {
          initrd.kernelModules = [ "i915" ];
          loader.grub = {
            device = "/dev/sda";
            splashImage = ../teeny/darktrees.png;
          };
        };

        networking.hostName = "lappy"; # Define your hostname.
        # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

        # Configure network proxy if necessary
        # networking.proxy.default = "http://user:password@proxy:port/";
        # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

        # Enable touchpad support (enabled default in most desktopManager).
        # services.xserver.libinput.enable = true;

        # List packages installed in system profile. To search, run:
        # $ nix search wget
        environment.systemPackages = with pkgs; [
          #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
          #  wget
        ];

        # Some programs need SUID wrappers, can be configured further or are
        # started in user sessions.
        # programs.mtr.enable = true;
        # programs.gnupg.agent = {
        #   enable = true;
        #   enableSSHSupport = true;
        # };

        # List services that you want to enable:

        # Enable the OpenSSH daemon.
        # services.openssh.enable = true;

        # Open ports in the firewall.
        # networking.firewall.allowedTCPPorts = [ ... ];
        # networking.firewall.allowedUDPPorts = [ ... ];
        # Or disable the firewall altogether.
        # networking.firewall.enable = false;

      }
    )
  ];
  specialArgs = {
    primaryUser = "abentley";
  };
}
