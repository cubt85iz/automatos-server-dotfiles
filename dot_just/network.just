# Generates wireguard keypair
[group('Networking')]
[group('Wireguard')]
generate-wg-keypair interface="wg0":
  wg genkey | tee /etc/wireguard/{{ interface }} | wg pubkey > /etc/wireguard/{{ interface }}.pub

# Shows listening TCP and UDP ports
[group('Networking')]
show-listen-ports:
  sudo ss -lutpn | grep -v aardvark-dns

# Shows network interfaces
[group('Networking')]
show-network-connections:
  nmcli -p --fields DEVICE,TYPE,STATE con show | grep -v podman

# Show exported paths for NFS
[group('Networking')]
[group('NFS')]
show-nfs-exports:
  showmount -e

# Shows status for wireguard interface
[group('Networking')]
[group('Wireguard')]
show-vpn-status interface="wg0":
  sudo wg show {{ interface }}

