let 
  pkgs = import <nixpkgs> { };
in
{
  enable = true;
  functions = {
    backups_open_latest = "
      cd $argv[1] # Pass a path
      set PRIVATE ~/backups/private.pem
      set LATEST (duplicacy list | tail -n1 | awk '{print $4}')
      duplicacy restore -key $PRIVATE -r $LATEST -overwrite -ignore-owner
     ";
    mnt = "
      lsblk
      read -P 'Specify partition prefix (/dev/XXX): ' PART
      thunar (udisksctl mount -b /dev/$PART | awk -F ' at ' '{print $2}' | cut -d. -f1)
    ";
    unmnt = "
      lsblk
      read -P 'Specify partition prefix (/dev/XXX): ' PART
      udisksctl unmount -b /dev/$PART
    ";
    wpa_add_network = "
      read -P 'SSID: ' SSID
      read -P 'PSK: ' PSK
      wpa_passphrase $SSID $PSK >> /etc/wpa_supplicant/wpa_supplicant-wlp4s0.conf
      echo 'Wrote to /etc/wpa_supplicant/wpa_supplicant-wlp4s0.conf'
      echo 'Check wpa_cli -> status'
    ";
  };
  interactiveShellInit = "";
  loginShellInit = "";
  plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
        sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
      };
    }
  ];
  promptInit = "
    any-nix-shell fish --info-right | source
  ";
  shellAliases = {
    # Utilities
    groups = "id (whoami)";
    a = "alsamixer";
    node = "env NODE_NO_READLINE=1 rlwrap node";
    # bspokeLight
    backwheel="bSpokeLight --offset '-1' --rotation '11' --output backwheel.bin";
    frontwheel="bSpokeLight --offset '-1' --rotation '1.5' --output frontwheel.bin";
    # Exercism
    exer_ts="cd ~/exercism/typescript && nix-shell -p exercism yarn";
  };
}
