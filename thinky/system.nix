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
        (pkgs.symlinkJoin {
          name = "shotwell-fixed";
          paths = [ pkgs.shotwell ];
          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild = ''
            # Remove the broken binary wrapper created by nixpkgs
            rm $out/bin/shotwell

            # Re-wrap the real underlying binary with the correct SVG loader directory
            makeWrapper ${pkgs.shotwell}/bin/.shotwell-wrapped $out/bin/shotwell \
              --prefix GDK_PIXBUF_MODULEDIR : "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders" \
              --prefix XDG_DATA_DIRS : "${pkgs.adwaita-icon-theme}/share:${pkgs.gsettings-desktop-schemas}/share"
          '';
        })
      ];
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
