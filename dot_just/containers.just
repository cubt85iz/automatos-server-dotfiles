import "shared.just"

backup-postgres-db container database destination:
  #!/usr/bin/env bash

  set -euo pipefail

  CONTAINER={{ container }}
  DATABASE={{ database }}
  DESTINATION={{ destination }}

  if just is-container-active "$CONTAINER"; then
    # If provided destination ends with a forward slash then assume the provided value is a
    # directory and append the default backup file name. Otherwise, assume the provided value
    # is a file.
    DESTINATION=$([[ "$DESTINATION" =~ /.*\/$ ]] && echo "${DESTINATION}${DATABASE}.sql" || echo "$DESTINATION")

    # Confirm file does not exist and necessary directories have been created before proceeding.
    [ ! -f "$DESTINATION" ] && [ -d "${DESTINATION%/*}" ] || mkdir -p "${DESTINATION%/*}"

    # Backup database to local data directory.
    sudo podman exec -it $CONTAINER pg_dump -U postgres --clean --create --file="$DESTINATION" --if-exists --quote-all-identifiers $DATABASE

    # Transfer database to destination
    sudo podman cp "$CONTAINER":'$PGDATA'/"$DATABASE.sql" "$DESTINATION"
  else
    just -f "{{ justfile() }}" stderr "Container ($CONTAINER) is not running."
  fi

[private]
get-container-status-helper container:
  #!/usr/bin/env bash

  set -euo pipefail

  CONTAINER_PATH={{ container }}

  # Colors
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  NC='\033[0m'

  CONTAINER_FILE=${CONTAINER_PATH##*/}
  CONTAINER_NAME=${CONTAINER_FILE%.*}

  # Get container health if available.
  # Ref: https://github.com/casey/just/issues/971
  CONTAINER_HEALTH=$(sudo podman inspect --format="{{{{.State.Health.Status}}" $CONTAINER_NAME 2>/dev/null || true)

  # Colorize output
  CONTAINER_ACTIVE=$(systemctl is-active $CONTAINER_NAME 2>/dev/null || true)
  if [ "$CONTAINER_ACTIVE" == "active" ]; then
    CONTAINER_STATUS=$(echo -n "${GREEN}${CONTAINER_ACTIVE}" && [ -z "$CONTAINER_HEALTH" ] && echo "${NC}" || echo " ($CONTAINER_HEALTH)${NC}")
  else
    CONTAINER_STATUS=$(echo -n "${YELLOW}${CONTAINER_ACTIVE}" && [ -z "$CONTAINER_HEALTH" ] && echo "${NC}" || echo " (${CONTAINER_HEALTH}${NC})")
  fi
  
  just -f "{{ justfile() }}" stdout "$CONTAINER_NAME: $CONTAINER_STATUS"


# Gets container status
[group('Containers')]
get-container-status container="all":
  #!/usr/bin/env bash

  set -euo pipefail

  CONTAINER={{ container }}

  if [ "$CONTAINER" == "all" ]; then
    readarray -t CONTAINERS < <(ls -1 /etc/containers/systemd/*.container)

    for CONTAINER_PATH in ${CONTAINERS[@]}; do
      just get-container-status-helper "$CONTAINER_PATH"
    done
  else
    if [ -f "/etc/containers/systemd/{{ container }}.container" ]; then
      just get-container-status-helper "/etc/containers/systemd/{{ container }}.container"
    else
      just -f "{{ justfile() }}" stderr "The specified container ({{ container }}) does not exist."
      exit 1
    fi
  fi

[private]
is-container-active container:
  @sudo systemctl is-active {{ container }} &> /dev/null