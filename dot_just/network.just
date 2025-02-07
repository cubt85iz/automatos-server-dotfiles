# Generates wireguard keypair
generate-wg-keypair interface="wg0":
  wg genkey | tee /etc/wireguard/{{ interface }} | wg pubkey > /etc/wireguard/{{ interface }}.pub

# Shows listening TCP and UDP ports
show-listen-ports:
  sudo ss -lutpn | grep -v aardvark-dns

# Shows network interfaces
show-network-connections:
  nmcli -p --fields DEVICE,TYPE,STATE con show | grep -v podman

# Shows status for wireguard interface
show-vpn-status interface="wg0":
  sudo wg show {{ interface }}

