{ config, pkgs, ... }:

{
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import <nixpkgs-unstable> {
        # Inherit config if set
        config = config.nixpkgs.config;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs.lib;
    map (pack: getAttrFromPath (splitString "." pack) pkgs) (import ./pkgs.nix);

  # Programs
  programs.rofi = {
    enable = true;
    theme = "config.files/rofi/material";
  };

  programs.git = {
    enable = true;
    userName = "ja0nz";
    userEmail = "mail@ja.nz";
    signing.signByDefault = true;
    signing.key = "079EC8E6";
  };

  # Services
  services.redshift = {
    enable = true;
    latitude = "49.826110";
    longitude = "9.923210";
  };

  services.nextcloud-client = {
    enable = true;
  };

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
