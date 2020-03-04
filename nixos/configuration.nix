# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jan_nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "neo";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  hardware.pulseaudio.enable = true;
  # Enable because user shell is fish
  programs.fish.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbVariant = "neo,nodeadkeys";
  services.xserver.xkbOptions = "grp:alt_shift_toggle";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the XFCE Desktop Environment.
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jan = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  fileSystems."/home/jan" = {
    device = "/dev/disk/by-label/HOME";
    options = ["rw" "noatime"];
    encrypted = {
     enable = true;
     blkDev = "/dev/sda5";
     label = "home";
    };
  };

  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  

  ####################### INACTIVE ###########################
  
  # List packages installed in system profile. To search, run:
  #environment.systemPackages = with pkgs; [
  #  wget
  #  libnotify
  #  cryptsetup
  #  vim
  #];
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  #programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable ALSA sound (pulseaudio does the job better)
  # sound.enable = true;
  # sound.extraConfig =
  #  ''
  #    defaults.pcm.!card 1
  #    defaults.ctl.!card 1
  #  '';
 
  # List services that you want to enable:
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;


}
