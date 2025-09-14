# Provide a base suite of console-based packages and configurations for all
# systems.
{ config, pkgs, ... }:
{
  programs = {
    git.enable = true;
    mtr.enable = true;
    # Install neovim
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
    };
    tmux.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    autoconf
    automake
    breezy
    colordiff
    dive
    ffmpeg
    file
    gcc
    gccStdenv
    gemini-cli
    graphviz
    htop
    just
    jsonnet
    libtool
    lsof
    mtr
    nethogs
    nixfmt-rfc-style
    nixfmt-tree
    nix-search
    nmap
    opentofu
    pciutils
    pkg-config
    python3
    python3Packages.autopep8
    python3Packages.flake8
    python3Packages.pygments
    ripgrep
    squashfsTools
    stdenv
    tree
    usbutils
    wget
    whois
  ];

  environment.variables = {
    # EDITOR already set by programs.neovim.defaultEditor = true;
    # EDITOR = "nvim";
  };
  environment.homeBinInPath = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.locate.enable = true;
  virtualisation.containers.enable = true;
}
