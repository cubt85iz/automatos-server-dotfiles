# Enable Starship
enable-starship:
  #!/usr/bin/env bash

  set -euo pipefail

  cat > $HOME/.bashrc.d/99-starship.sh <<'EOF'
  #!/usr/bin/env bash

  eval "$(starship init bash)"
  EOF

# Install Starship shell prompt
[group('Shell')]
install-starship:
  #!/usr/bin/env bash

  set -euo pipefail

  mkdir -p $HOME/.local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $HOME/.local/bin
