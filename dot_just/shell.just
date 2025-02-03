# Install Starship shell prompt
install-starship:
  #!/usr/bin/env bash

  set -euo pipefail

  mkdir -p $HOME/.local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $HOME/.local/bin
