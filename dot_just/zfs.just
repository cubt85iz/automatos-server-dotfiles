import "shared.just"

# Retrieves the health of the specified pool
[group('ZFS')]
get-pool-health pool:
  zpool list -H -o health {{ pool }}

# Lists the disks in the specified pool
[group('ZFS')]
show-disks pool:
  #!/usr/bin/env bash

  set -euo pipefail

  # Colors
  source <(just -f "{{ justfile() }}" get-colors)

  for DEVICE in $(zpool list -vHP {{ pool }} | grep /dev | awk -F '\t' '{printf "%s\n", $2}'); do
    DEVICE_HEALTH=$(zpool list -vHP tank | grep $DEVICE | awk -F '\t' '{printf "%s\n", $11}')
    case DEVICE_HEALTH in
      ONLINE)
        DEVICE_HEALTH=$(echo "${GREEN}${DEVICE_HEALTH}${NC}")
        ;;
      DEGRADED)
        DEVICE_HEALTH=$(echo "${YELLOW}${DEVICE_HEALTH}${NC}")
        ;;
      *)
        DEVICE_HEALTH=$(echo "${RED}${DEVICE_HEALTH}${NC}")
        ;;
    esac
    PARENT_DEVICE=/dev/$(lsblk -no "PKNAME" $DEVICE)
    echo -e "$DEVICE $(lsblk -n -r -d -o "MODEL,SERIAL" $PARENT_DEVICE) $DEVICE_HEALTH"
  done

# Lists all faulted disks in the specified pool
[group('ZFS')]
show-faulted-disks pool:
  @just show-disks {{ pool }} | grep -v ONLINE || echo "No faulted disks found for {{ pool }}."
