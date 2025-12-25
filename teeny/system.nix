# Provide a NixOS system configuration for the teeny machine.
{
  self,
  nixpkgs,
  old-nixpkgs,
  home-manager,
  ...
}:
let
  custom = (
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      boot.initrd.kernelModules = [ "i915" ];
      # Bootloader.

      # Don't actually want this for booting, but this seems to be how you get it
      # at all.
      boot.supportedFilesystems = [
        "bcachefs"
      ];

      fileSystems."/mnt/bcachefs" = {
        device = "/dev/disk/by-uuid/33ac4789-8fdc-4774-ab7a-1f4384ca0aeb";
        fsType = "bcachefs";
        options = [ "nofail" ];
      };

      fileSystems."/mnt/250G" = {
        device = "/dev/disk/by-uuid/b1724b65-c2ac-4d18-905b-9dfd1058339a";
        fsType = "ext4";
        options = [ "noauto" ];
      };
      networking.hostName = "teeny"; # Define your hostname.

      # This is more of a graphical-server config, but I only have one of those.
      services.xserver.displayManager.gdm.autoSuspend = false;
      services.iperf3 = {
        enable = true;
        openFirewall = true;
      };
      environment.systemPackages = [
        pkgs.mplayer
      ];

      # Enable 5.1 surround sound via passthrough
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
        # This is for applications that output multichannel LPCM.
        # PipeWire will attempt to encode it to a compressed format if the
        # sink supports it (which we enable below).
        config.pipewire."context.properties" = {
          "default.audio.channels" = 6;
          "default.audio.position" = "[ FL FR FC LFE SL SR ]";
        };

        # This enables passthrough for compressed audio formats like Dolby Digital (AC3)
        # and DTS. It creates a config file for WirePlumber (the PipeWire session manager)
        # that applies these settings to your HDMI output.
        wireplumber.configPackages = [
          (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-hdmi-passthrough.lua" ''
            rule = {
              matches = {
                {
                  -- Matches all HDMI audio outputs
                  { "node.name", "matches", "alsa_output.pci-*-hdmi-*" },
                },
              },
              apply_properties = {
                -- Enables PCM, AC3 (Dolby), E-AC3 (Dolby Digital Plus), and DTS
                ["iec958.codecs"] = { "pcm", "ac3", "eac3", "dts" },
              },
            }
            table.insert(alsa_monitor.rules, rule)
          '')
        ];
      };

      users.users = {
        jellyfin.extraGroups = [ "docker" ];
      };
    }
  );
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    old-nixpkgs = old-nixpkgs;
  };
  system = "x86_64-linux";
  modules = [
    ../base-configuration.nix
    ./hardware-configuration.nix
    ../suites/base.nix
    ../suites/graphical-computer.nix
    ../features/options.nix # Add the new options file
    home-manager.nixosModules.home-manager
    custom
    (import ../features/zfs-support.nix {
      raidpool = "raidpool2";
      devNode = "/dev/disk/by-partuuid/ed4867b2-c1f2-7249-9a71-a904b9d8d9f8";
      hostId = "21d28d23";
    })
    {
      # Enable features
      myFeatures = {
        jellyfin = {
          enable = true;
          primaryUser = "abentley";
        };
        docker = {
          enable = true;
          primaryUser = "abentley";
        };
        incus = {
          enable = true;
          primaryUser = "abentley";
        };
        grub = {
          bootMode = "bios";
          resolution = "1920x1080x32";
          splashImage = ./darktrees.png;
          device = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21HNXBG433208Y";
        };
        # podman.enable = true; # If it was intended to be enabled
        samba = {
          enable = true;
          name = "teeny";
          shares = {
            "music" = {
              "path" = "/mnt/bcachefs/Music";
              "browseable" = "yes";
              "read only" = "yes";
              "guest ok" = "yes";
              "create mask" = "0644";
              "directory mask" = "0755";
              "force user" = "jellyfin";
              "force group" = "jellyfin";
            };
          };
        };
        hyprland = {
          enable = true;
          primaryUser = "abentley";
        };
        flakeSupport.enable = true;
        earlyConsole = {
          enable = true;
          consoleFontName = "spleen";
        };
        homeManager.enable = true;
      };
    }
  ];
}
