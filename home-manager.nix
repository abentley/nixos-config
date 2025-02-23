{ config, pkgs, ... }:
let
  neovim_config = {
    enable = true;
    extraConfig = ''
      colorscheme murphy
      set shiftwidth=4
      set expandtab
    '';
  };
in
{
  imports = [ <home-manager/nixos> ];

  home-manager.users.root =
    { pkgs, ... }:
    {
      home.stateVersion = "24.11";
      programs.bash.enable = true;
      programs.neovim = neovim_config;
    };
  home-manager.users.abentley =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.httpie ];
      programs.bash.enable = true;
      home.stateVersion = "24.11";
      programs.neovim = neovim_config;
    };
}
