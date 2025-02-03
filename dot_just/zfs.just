set ignore-comments := true

[private]
default:
  @just -l

# Retrieves the health of the specified pool
get-pool-health pool:
  zpool list -H -o health {{ pool }}

# Lists the disks in the specified pool
show-disks pool:
  #!/usr/bin/env bash

  set -euo pipefail

  for DEVICE in $(zpool list -vHP {{ pool }} | grep /dev | awk -F '\t' '{printf "%s\n", $2}'); do
    DEVICE_HEALTH=$(zpool list -vHP tank | grep $DEVICE | awk -F '\t' '{printf "%s\n", $11}')
    PARENT_DEVICE=/dev/$(lsblk -no "PKNAME" $DEVICE)
    echo "$DEVICE $(lsblk -n -r -d -o "MODEL,SERIAL" $PARENT_DEVICE) $DEVICE_HEALTH"
  done

# Lists all faulted disks in the specified pool
show-faulted-disks pool:
  @just show-disks {{ pool }} | grep -v ONLINE || echo "No faulted disks found for {{ pool }}."
