# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
  ];
  virtualisation.docker.enable = true;

  # Bootloader.
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
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

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.abentley = {
    isNormalUser = true;
    description = "Aaron Bentley";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  users.users.jellyfin.extraGroups = [ "docker" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    # Make sure the font packages are available system-wide if not pulled by kmscon itself
    # hack-font
    # source-code-pro
    # dejavu_fonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
