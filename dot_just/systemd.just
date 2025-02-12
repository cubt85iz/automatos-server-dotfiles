# Generates svg file showing service dependencies
generate-dependency-svg:
  #!/usr/bin/env bash
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  sudo systemd-analyze dot | dot -Tsvg > ~/systemd-dependencies-$TIMESTAMP.svg
  echo "SVG file output to ~/systemd-dependencies-$TIMESTAMP.svg"

# Generates svg file showing startup times
generate-startup-svg:
  #!/usr/bin/env bash
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  sudo systemd-analyze plot > ~/systemd-startup-$TIMESTAMP.svg
  echo "SVG file output to ~/systemd-startup-$TIMESTAMP.svg"

# Show the time it takes to start services
show-startup-times:
  sudo systemd-analyze blame


