{
  enable = true;
  extraConfig = ''
    colorscheme murphy
    set shiftwidth=4
    set expandtab
    se tabstop=4
    se smarttab
    se hlsearch
    se visualbell
    se list
    se listchars=tab:>.,trail:-
    autocmd FileType nix se shiftwidth=2
  '';
}
