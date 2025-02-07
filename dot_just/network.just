show-listen-ports:
  sudo ss -lutpn | grep -v aardvark-dns

show-network-connections:
  nmcli -p --fields DEVICE,TYPE,STATE con show | grep -v podman

show-vpn-status interface="wg0":
  sudo wg show {{ interface }}

