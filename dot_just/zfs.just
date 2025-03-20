# Retrieves the health of the specified pool
[group('ZFS')]
get-pool-health pool="":
  #!/usr/bin/env bash

  set -euo pipefail

  POOL="{{ pool }}"

  if [ -n "$POOL" ]; then
    zpool list -H -o health $POOL
  else
    zpool list -H -o name,health
  fi

# Lists the disks in the specified pool
[group('ZFS')]
show-disks pool:
  #!/usr/bin/env bash

  set -euo pipefail

  POOL="{{ pool }}"

  # Colors
  source <(just get-colors)

  for DEVICE in $(zpool list -vHP $POOL | grep /dev | awk -F '\t' '{printf "%s\n", $2}'); do
    DEVICE_HEALTH=$(zpool list -vHP $POOL | grep $DEVICE | awk -F '\t' '{printf "%s\n", $11}')
    case $DEVICE_HEALTH in
      ONLINE)
        DEVICE_HEALTH=$(echo "${GREEN}${DEVICE_HEALTH}${NC}")
        ;;
      DEGRADED|RESILVERING)
        DEVICE_HEALTH=$(echo "${YELLOW}${DEVICE_HEALTH}${NC}")
        ;;
      SPARE)
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
  @just show-disks {{ pool }} | grep -v ONLINE || just stdout "No faulted disks found for {{ pool }}."
