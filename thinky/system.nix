# Provide a NixOS system configuration for the thinky machine.
{
  self,
  nixpkgs,
  home-manager,
  antigravity-nix,
  ...
}:
let
  custom = (
    { config, pkgs, ... }:
    {
      # Bootloader.
      boot = {
        loader = {
          # grub.efiInstallAsRemovable = true;
          # grub.font = "${pkgs.hack-font}/share/fonts/hack/Hack-Regular.ttf";
          # grub.fontSize = 24;
          grub.default = "saved";

          efi.canTouchEfiVariables = true;
        };
        initrd.kernelModules = [ "i915" ];
        kernelParams = [
          # Prevent Cool & Quiet on Lap from forcing "balanced" mode.
          # This allows "low power" to be used.
          "thinkpad_acpi.profile_force=-1"
        ];
      };

      # boot.loader.systemd-boot.enable = true;
      # Conflicts with boot.loader.grub.efiInstallAsRemovable = true;
      # boot.plymouth.enable = true;

      networking.hostName = "thinky"; # Define your hostname.
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
      environment.systemPackages = [
        (pkgs.shotwell.overrideAttrs (old: {
          postInstall = ''
            # Nixpkgs' shotwell postInstall sets GDK_PIXBUF_MODULE_FILE with only libheif.lib,
            # which unintentionally strips librsvg from the pixbuf loader cache and breaks SVG icons.
            # Adding librsvg ensures both HEIF and SVG loaders are available while preserving all
            # GTK schemas (like org.gtk.Settings.FileChooser), typelibs, and plugins set by wrapGAppsHook3.
            export GDK_PIXBUF_MODULE_FILE="${
              pkgs.gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
                extraLoaders = [
                  pkgs.libheif.lib
                  pkgs.librsvg
                ];
              }
            }"
          '';
        }))
      ];
      # This device can only be used with specific Thinkpad docks that I don't
      # own, so disable it to save power.
      services.udev.extraRules = ''
        # Unbind PCI 0000:00:1f.6 directly via e1000e's unbind attribute
        ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:1f.6", RUN+="${pkgs.bash}/bin/bash -c 'echo 0000:00:1f.6 > /sys/bus/pci/drivers/e1000e/unbind'"
      '';
    }
  );
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ../physical-machine.nix
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/laptop.nix
    ../suites/audio-production.nix
    (import ../suites/dev.nix antigravity-nix)
    ../features/options.nix # Add the new options file
    home-manager.nixosModules.home-manager
    custom
    (
      { pkgs, ... }:
      {
        # Enable features
        myFeatures = {
          grub = {
            bootMode = "efi";
            resolution = "1366x768x32";
            splashImage = pkgs.fetchurl {
              url = "https://assets.aaronbentley.com/treemoon-3.png";
              sha256 = "4d7b02f8e950f8bf5e9b45cf993d8307ad3778980d131e1d8d4cf09aa9fdfd16";
            };
          };
          hyprland = {
            enable = true;
            primaryUser = "abentley";
          };
          flakeSupport.enable = true;
          earlyConsole = {
            enable = true;
            consoleFontName = "spleen"; # Set consoleFontName for earlyConsole
          };
          homeManager.enable = true;
        };
      }
    )
  ];
}
