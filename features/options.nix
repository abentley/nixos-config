# /home/abentley/hacking/nixos-config/features/options.nix
{
  config,
  pkgs,
  lib,
  old-nixpkgs,
  ...
}:

{
  options.myFeatures = {
    autoRotation = {
      enable = lib.mkEnableOption "Enable automatic screen rotation.";
    };

    earlyConsole = {
      enable = lib.mkEnableOption "Enable early console setup.";
      consoleFontName = lib.mkOption {
        type = lib.types.str;
        default = "spleen"; # Default to spleen as seen in the original file
        description = "The name of the console font to use (e.g., 'spleen', 'terminus').";
      };
    };

    flakeSupport = {
      enable = lib.mkEnableOption "Enable Nix flakes.";
    };

    grub = {
      bootMode = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "efi"
            "bios"
          ]
        );
        default = null;
        description = "The boot mode for GRUB (EFI or BIOS). Nullable.";
      };
      device = lib.mkOption {
        type = lib.types.str;
        default = "/dev/sda"; # A sensible default for BIOS
        description = "The device to install GRUB to (e.g., \"/dev/sda\"). Only applicable for BIOS boot mode.";
      };
      resolution = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "The GRUB resolution (e.g., \"1920x1080\"). Nullable.";
      };
      splashImage = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "The path to the GRUB splash image. Nullable.";
      };
    };

    homeManager = {
      enable = lib.mkEnableOption "Enable Home Manager.";
    };

    hyprland = {
      enable = lib.mkEnableOption "Enable Hyprland compositor.";
      primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "The primary user for Hyprland configuration.";
      };
    };

    incus = {
      enable = lib.mkEnableOption "Enable Incus virtualization.";
      primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "The primary user for Incus configuration.";
      };
    };

    jellyfin = {
      enable = lib.mkEnableOption "Enable Jellyfin media server.";
      primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "The primary user for Jellyfin configuration.";
      };
    };

    podman = {
      enable = lib.mkEnableOption "Enable Podman.";
    };

    samba = {
      enable = lib.mkEnableOption "Enable Samba file sharing.";
      name = lib.mkOption {
        type = lib.types.str;
        description = "The NetBIOS name for the Samba server.";
      };
      shares = lib.mkOption {
        type = lib.types.attrsOf lib.types.attrs;
        default = { };
        description = "Attribute set of Samba shares.";
      };
    };

    steam = {
      enable = lib.mkEnableOption "Enable Steam.";
    };

    systemdBoot = {
      enable = lib.mkEnableOption "Enable systemd-boot.";
    };
  };

  config = lib.mkMerge [
    # Auto-rotation feature
    (lib.mkIf config.myFeatures.autoRotation.enable {
      hardware.sensor.iio.enable = true;
      programs.iio-hyprland.enable = true;
      environment.systemPackages = with pkgs; [
        gjs
        iio-hyprland
        jq
        gnomeExtensions.screen-rotate
      ];
    })

    # Early console feature
    (lib.mkIf config.myFeatures.earlyConsole.enable (
      let
        consoleFontName = config.myFeatures.earlyConsole.consoleFontName;
        consoleFonts = {
          spleen = rec {
            path = "${pkg}/share/consolefonts/spleen-32x64.psfu";
            pkg = pkgs.spleen;
          };
          terminus = rec {
            path = "${pkg}/share/consolefonts/ter-i32b.psf.gz";
            pkg = pkgs.terminus_font;
          };
        };
        consoleFont = consoleFonts.${consoleFontName};
      in
      {
        console = {
          earlySetup = true;
          font = consoleFont.path;
          packages = [ consoleFont.pkg ];
          keyMap = "us";
        };
      }
    ))

    # Flake enablement feature
    (lib.mkIf config.myFeatures.flakeSupport.enable {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    })

    # GRUB feature (EFI)
    (lib.mkIf (config.myFeatures.grub.bootMode == "efi") {
      boot.loader.grub = {
        enable = true;
        useOSProber = true;
        device = lib.mkDefault "nodev";
        efiSupport = true;
        splashImage = config.myFeatures.grub.splashImage;
        gfxmodeEfi = config.myFeatures.grub.resolution;
      };
      boot.loader.efi.canTouchEfiVariables = true;
      environment.systemPackages = with pkgs; [
        efibootmgr
      ];
    })

    # GRUB feature (BIOS)
    (lib.mkIf (config.myFeatures.grub.bootMode == "bios") {
      boot.loader.grub = {
        enable = true;
        useOSProber = true;
        device = config.myFeatures.grub.device; # Use the configurable device
        splashImage = config.myFeatures.grub.splashImage;
        gfxmodeBios =
          if config.myFeatures.grub.resolution == null then "1024x768" else config.myFeatures.grub.resolution;
      };
    })

    # Home Manager feature
    (lib.mkIf config.myFeatures.homeManager.enable {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.abentley = import ../users/abentley.nix;
        users.root = import ../users/root.nix;
        backupFileExtension = "backup";
      };
    })

    # Hyprland feature
    (lib.mkIf config.myFeatures.hyprland.enable (
      let
        primaryUser = config.myFeatures.hyprland.primaryUser;
      in
      import ./hyprland.nix { inherit pkgs primaryUser; }
    ))

    # Incus feature
    (lib.mkIf config.myFeatures.incus.enable (
      let
        primaryUser = config.myFeatures.incus.primaryUser;
      in
      {
        networking.firewall.trustedInterfaces = [ "incusbr0" ];
        networking.nftables.enable = true;
        users.users.${primaryUser} = {
          extraGroups = [ "incus-admin" ];
        };
        virtualisation.incus.enable = true;
        virtualisation.incus.ui.enable = true;
      }
    ))

    # Jellyfin feature
    (lib.mkIf config.myFeatures.jellyfin.enable (
      let
        primaryUser = config.myFeatures.jellyfin.primaryUser;
        old-pkgs = import old-nixpkgs { system = "x86_64-linux"; };
        comskip = (pkgs.callPackage ../packages/comskip.nix { pkgs = old-pkgs; });
      in
      {
        services.jellyfin.enable = true;
        services.jellyfin.openFirewall = true;
        environment.systemPackages = [
          pkgs.libhdhomerun
          pkgs.hdhomerun-config-gui
          pkgs.vlc
          comskip
        ];
        users.users.${primaryUser}.extraGroups = [ "jellyfin" ];
        networking.firewall.extraInputRules = "udp sport 65001 accept";
      }
    ))

    # Podman feature
    (lib.mkIf config.myFeatures.podman.enable {
      virtualisation.containers.enable = true;
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
      environment.systemPackages = with pkgs; [
        dive
        podman-tui
        docker-compose
      ];
    })

    # Samba feature
    (lib.mkIf config.myFeatures.samba.enable (
      let
        name = config.myFeatures.samba.name;
        shares = config.myFeatures.samba.shares;
      in
      {
        services.samba = {
          enable = true;
          openFirewall = true;
          settings = {
            global = {
              "workgroup" = "WORKGROUP";
              "security" = "user";
              "server string" = name;
              "netbios name" = name;
              "dos charset" = "CP850";
              "unix charset" = "UTF-8";
              "hosts allow" = "192.168.91. 127.0.0.1 localhost";
              "hosts deny" = "0.0.0.0/0";
              "guest account" = "nobody";
              "map to guest" = "bad user";
            };
          }
          // shares;
        };
        services.samba-wsdd = {
          enable = true;
          openFirewall = true;
        };
        networking.firewall.enable = true;
        networking.firewall.allowPing = true;
      }
    ))

    # Steam feature
    (lib.mkIf config.myFeatures.steam.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    })

    # systemd-boot feature
    (lib.mkIf config.myFeatures.systemdBoot.enable {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })
  ];
}
