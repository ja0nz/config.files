{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    htop
    kitty
    fish
    rofi
    emacs
    neovim
    git
    ripgrep
    fzf
    bat
    okular
    unp
    redshift
    mu
    isync
    pandoc
    nextcloud-client
    # Build stuff
    direnv
    graphviz
    #Rust
    ##pkgs.gcc
    ##pkgs.rustup

  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
}
