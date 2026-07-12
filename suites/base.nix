# Provide a base suite of console-based packages and configurations for all
# systems.
{ config, pkgs, ... }:
{
  programs = {
    command-not-found.enable = true;
    git.enable = true;
    mtr.enable = true;
    # Install neovim
    neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = false;
      withRuby = false;
      viAlias = true;
    };
    tmux.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    atop
    autoconf
    automake
    breezy
    btop
    colordiff
    dive
    ffmpeg
    file
    gcc
    gccStdenv
    graphviz
    htop
    iftop
    iperf3
    just
    jsonnet
    keychain
    libtool
    lsof
    macchina
    ncdu
    nethogs
    nixfmt
    nix-diff
    nix-search
    nmap
    ntfs3g
    openssl_3
    opentofu
    pciutils
    pigz
    pkg-config
    pv
    python3
    python3Packages.autopep8
    python3Packages.flake8
    python3Packages.pygments
    ripgrep
    squashfsTools
    stdenv
    sysdig
    tree
    usbutils
    uv
    wavemon
    wget
    whois
  ];

  environment.variables = {
    # EDITOR already set by programs.neovim.defaultEditor = true;
    # EDITOR = "nvim";
  };
  environment.homeBinInPath = true;

  # Provide an alternative to gnome-keychain if not running.
  programs.ssh.extraConfig = "AddKeysToAgent yes";
  programs.bash.interactiveShellInit = ''
  # Force keychain to borrow GNOME's existing socket rather than spawning a new agent
  eval "$(keychain --eval --inherit any-once --dir /run/user/1000/keychain --quiet)"
'';

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = true;
  services.locate.enable = true;
  virtualisation.containers.enable = true;
}
