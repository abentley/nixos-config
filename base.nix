{ config, pkgs, ... }:
{
  # Install neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;

}
