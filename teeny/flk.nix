{
  self,
  nixpkgs,
  old-nixpkgs,
  home-manager,
  ...
}:
let
  custom = (
    { config, pkgs, ... }:

    {
      virtualisation.docker.enable = true;

      # Bootloader.
      boot.loader.grub = {
        gfxmodeBios = "1920x1080x32";
        splashImage = ./darktrees.png;
      };

      # Disable the standard kernel console setup as kmscon will take over
      # This prevents conflicts and ensures kmscon manages the TTYs
      #   console.enable = false;
      #   systemd.services.systemd-vconsole-setup.enable = false;
      #   systemd.services.reload-systemd-vconsole-setup.enable = false;

      #   services.kmscon = {
      #     enable = true;
      #     hwRender = true; # Enable hardware acceleration for better performance (recommended)
      #     keyMap = "us";   # Or your preferred keyboard layout, e.g., "de", "fr"
      #     # useXkbConfig = true; # If you want to use your X server's keyboard settings (optional)
      #
      #     # Configure fonts for kmscon. This is where you set your larger font.
      #     # You can specify multiple fonts; kmscon will try them in order.
      #     # Use standard font names that fontconfig can resolve.
      #     # Make sure the font packages are available in your system environment.
      #     fonts = [
      #       {
      #         name = "Hack"; # A popular monospace font, usually looks good.
      #         package = pkgs.hack-font; # Ensure this package is in your environment.systemPackages or is pulled by other means
      #       }
      #       {
      #         name = "Source Code Pro";
      #         package = pkgs.source-code-pro;
      #       }
      #       {
      #         name = "DejaVu Sans Mono"; # Another good fallback
      #         package = pkgs.dejavu_fonts;
      #       }
      #       # You can also specify an exact font file if needed, though less common for kmscon
      #       # {
      #       #   name = "${pkgs.fira-code}/share/fonts/opentype/FiraCode-Retina.otf";
      #       #   package = pkgs.fira-code;
      #       # }
      #     ];
      #
      #     # This is the crucial part for controlling the font size.
      #     # You can set font-size directly here.
      #     extraConfig = ''
      #       font-size=96 # Start with a reasonable size, adjust as needed for 4K
      #       # You can also set a default font if you don't use the 'fonts' option above
      #       # font-name=Hack
      #       # Other useful options:
      #       # xkb-options=terminate:ctrl_alt_bksp # Allows Ctrl+Alt+Backspace to kill X/Wayland session
      #       # login=/bin/bash --login # If you want to automatically log in to a shell (not recommended for security)
      #     '';
      #
      #     # Optional: If you want to customize command-line options passed to kmscon
      #     # extraOptions = "--term xterm-256color";
      #   };

      users.users.abentley.extraGroups = [ "docker" ];
      users.users.jellyfin.extraGroups = [ "docker" ];

      environment.systemPackages = with pkgs; [
        # Make sure the font packages are available system-wide if not pulled by kmscon itself
        # hack-font
        # source-code-pro
        # dejavu_fonts
      ];
    }
  );
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hardware-configuration.nix
    ../suites/graphical-computer.nix
    ../features/jellyfin.nix
    ../features/incus.nix
    ../features/grub.nix
    ./teeny.nix
    ../suites/base.nix
    #      ../features/podman.nix
    ./samba-teeny.nix
    # ../../samba-vr.nix
    ../features/hyprland.nix
    ../features/early-console.nix
    ../base-configuration.nix
    home-manager.nixosModules.home-manager
    (import ../features/home-manager.nix)
    custom
  ];
  specialArgs = {
    primaryUser = "abentley";
    old-nixpkgs = old-nixpkgs;
    consoleFontName = "spleen";
  };
}
