# Enable Starship
enable-starship:
  #!/usr/bin/env bash

  set -euo pipefail

  # Enable Nerd Font Symbols
  starship preset nerd-font-symbols -o ~/.config/starship.toml

  # Enable starship shell
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

  # Download and install fonts
  curl -sSL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.tar.xz | tar xJv -C $HOME/.fonts
