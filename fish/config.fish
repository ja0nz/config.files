# Startx on tty1
if [ (tty) = "/dev/tty1" ]
    startx && exit
end

set EDITOR vim
alias vim=nvim
set -x PATH $PATH ~/.cargo/bin
set -x PATH $PATH ~/.yarn/bin

# Add network
function add_network
    read -P "SSID: " SSID
    read -P "PSK: " PSK
    wpa_passphrase $SSID $PSK >> /etc/wpa_supplicant/wpa_supplicant-wlp4s0.conf
    echo "Wrote to /etc/wpa_supplicant/wpa_supplicant-wlp4s0.conf"
    echo "Check 'wpa_cli' -> 'status'"
end

# Refresh session
alias ref="exec fish"

# Alias groups
alias groups="id (whoami)"

# Alias alsamixer
alias a="alsamixer"

# Alias slock lock display
# Or use rofi
alias s="slock"

function mnt
    lsblk
    read -P "Specify partition prefix (/dev/XXX): " PART
    thunar (udisksctl mount -b /dev/$PART | awk -F " at " '{print $2}' | cut -d. -f1)
end

function unmnt
    lsblk
    read -P "Specify partition prefix (/dev/XXX): " PART
    udisksctl unmount -b /dev/$PART
end
