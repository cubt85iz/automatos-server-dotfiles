get-colors:
  #!/usr/bin/env bash

  cat <<EOF
  NC='\033[0m'
  BLACK='\033[0;30m'
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  ORANGE='\033[0;33m'
  BLUE='\033[0;34m'
  PURPLE='\033[0;35m'
  CYAN='\033[0;36m'
  LIGHT_GRAY='\033[0;37m'
  DARK_GRAY='\033[1;30m'
  LIGHT_RED='\033[1;31m'
  LIGHT_GREEN='\033[1;32m'
  YELLOW='\033[1;33m'
  LIGHT_BLUE='\033[1;34m'
  LIGHT_PURPLE='\033[1;35m'
  LIGHT_CYAN='\033[1;36m'
  WHITE='\033[1;37m'
  EOF

# Outputs provided message to stderr in standardized format
[private]
stderr message level="ERROR":
  @>&2 echo "[{{ level }}] {{ message }}"

# Outputs provided message to stdout in standardized format
[private]
stdout message level="INFO":
  #! /usr/bin/env bash

  set -euo pipefail

  LEVEL="{{ level }}"
  MESSAGE="{{ message }}"

  if [ "$LEVEL" != "ERROR" ]; then
    echo -e "[{{ level }}] {{ message }}"
  else
    stderr "$MESSAGE"
  fi

[private]
file_exists $FILE:
  #!/usr/bin/env bash

  set -euox pipefail

  if [ ! -e "$FILE" ]; then
    stderr "ERROR: Provided file ($FILE) does not exist."
    exit 1
  fi


colors-test:
  #!/usr/bin/env bash
  source <(just -f "{{ justfile() }}" get-colors)
  echo -e "${RED}Am I red?${NC}"