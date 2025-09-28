{
  config,
  lib,
  pkgs,
  primaryUser,
  ...
}:
{
  environment.systemPackages = [
    pkgs.wslu
    pkgs.xdg-utils
  ];
  wsl.enable = true;
  wsl.defaultUser = "abentley";
  wsl.tarball.configPath = ../.;
  systemd.tmpfiles.settings = {
    # 1. Define a config file group name (e.g., "wsl-symlinks")
    "wsl-symlinks" = {
      # 2. Define the path (the key is the full path)
      "/usr/share/applications" = {
        # 3. Define the rule type (L+ for persistent symlink)
        "L+" = {
          # 4. Set the symlink target via the 'argument' attribute
          argument = "/run/current-system/sw/share/applications";
          # You can optionally define user, group, and mode here as well
          # user = "root";
          # group = "root";
        };
      };

      "/usr/share/icons" = {
        "L+" = {
          argument = "/run/current-system/sw/share/icons";
        };
      };
    };
  };
}
