import "shared.just"

# Generates svg file showing service dependencies
[group('Services')]
generate-dependency-svg:
  #!/usr/bin/env bash

  set -euo pipefail

  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  sudo systemd-analyze dot | dot -Tsvg > ~/systemd-dependencies-$TIMESTAMP.svg
  just -f "{{ justfile() }}" stdout "SVG file output to ~/systemd-dependencies-$TIMESTAMP.svg"

# Generates svg file showing startup times
[group('Services')]
generate-startup-svg:
  #!/usr/bin/env bash

  set -euo pipefail

  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  sudo systemd-analyze plot > ~/systemd-startup-$TIMESTAMP.svg
  just -f "{{ justfile() }}" stdout "SVG file output to ~/systemd-startup-$TIMESTAMP.svg"

# Show the time it takes to start services
[group('Services')]
show-startup-times:
  sudo systemd-analyze blame
