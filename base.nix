{ config, pkgs, ... }:
{
  # Install neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # It's fast
    ripgrep
    gccStdenv
    colordiff
    pkg-config
    autoconf
    automake
    stdenv
    libtool
    gcc
    git
    lsof
    python3
    file
    ffmpeg
    nixfmt-rfc-style
    htop
    pciutils
    usbutils
    nix-search
    breezy
    graphviz
    nethogs
    nmap
    opentofu
    tree
    wget
    whois
    squashfsTools
    dive
  ];

  environment.variables = {
    # EDITOR already set by programs.neovim.defaultEditor = true;
    # EDITOR = "nvim";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.locate.enable = true;
  virtualisation.containers.enable = true;
}
