{ config, pkgs, ... }:
    
{
  nixpkgs = {
    config = {
      packageOverrides = pkgs: {
        unstable = import <nixpkgs-unstable> {
          # Inherit config if set
          config = config.nixpkgs.config;
        };
      };
    };
    overlays = [ 
      (self: super: {
        # Deprecate nextcloud client
        #nextcloud-client = super.nextcloud-client.override {
	#  qtkeychain = pkgs.gnome3.libgnome-keyring;
	#};
      })
    ];
  };

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "${pkgs.firefox}/bin/firefox";
    };
    packages = with pkgs.lib;
      map (pack: getAttrFromPath (splitString "." pack) pkgs) (import ./pkgs.nix);
  
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "19.09";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # fish = import ./fish.nix;  Waiting for the next home manager release
    rofi = {
      enable = true;
      theme = "config.files/rofi/material";
    };
    git = {
      enable = true;
      userName = "ja0nz";
      userEmail = "mail@ja.nz";
      signing.signByDefault = true;
      signing.key = "079EC8E6";
    };
    gpg = {
      enable = true;
      settings = {
        no-comments = false;
	s2k-cipher-algo = "AES128";
      };
    };
    neovim = { 
      enable = true;
      extraConfig = ''
        set tabstop=2       " number of visual spaces per TAB
        set softtabstop=2   " number of spaces in tab when editing
        set shiftwidth=2    " number of spaces to use for autoindent
        set expandtab       " tabs are space
        set autoindent
        set copyindent      " copy indent from the previous line
	'';
      viAlias = true;
      vimAlias = true;
    };

  };
 
  services = {
    redshift = {
      enable = true;
      latitude = "49.826110";
      longitude = "9.923210";
    };
    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
  };

  xdg.enable = true;
  
}
