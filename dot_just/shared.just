# Outputs provided message to stderr in standardized format
[private]
stderr message level="ERROR":
  >&2 echo "{{ level }}: {{ message }}"

# Outputs provided message to stdout in standardized format
[private]
stdout message level="INFO":
  #! /usr/bin/env bash

  set -euox pipefail

  $LEVEL = "{{ level }}"
  $MESSAGE = "{{ message }}"

  if [ "$LEVEL" != "ERROR" ]; then
    echo "{{ level }}: {{ message }}"
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
