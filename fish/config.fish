set EDITOR vim
alias vim=nvim

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
