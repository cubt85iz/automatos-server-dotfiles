import "shared.just"

[group('Containers')]
get-container-status container="all":
  #!/usr/bin/env bash

  set -euo pipefail

  CONTAINER={{ container }}

  if [ "$CONTAINER" == "all" ]; then
    readarray -t CONTAINERS < <(ls -1 /etc/containers/systemd/*.container)

    for CONTAINER_PATH in ${CONTAINERS[@]}; do
      CONTAINER_FILE=${CONTAINER_PATH##*/}
      CONTAINER_NAME=${CONTAINER_FILE%.*}
      just -f "{{ justfile() }}" stdout "$CONTAINER_NAME: $(systemctl is-active $CONTAINER_NAME)"
    done
  else
    if [ -f "/etc/containers/systemd/{{ container }}.container" ]; then
      just -f "{{ justfile() }}" stdout "$CONTAINER_NAME: $(systemctl is-active $CONTAINER_NAME)"
    else
      just -f "{{ justfile() }}" stderr "The specified container ({{ container }}) does not exist."
      exit 1
    fi
  fi