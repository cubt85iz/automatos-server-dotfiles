# Disable logging of denials
[group('Firewall')]
disable-logging:
  sudo firewall-cmd --set-log-denied=off

# Enable logging of denials
[group('Firewall')]
enable-logging:
  sudo firewall-cmd --set-log-denied=all

# List all active zones
[group('Firewall')]
show-active-zones:
  sudo firewall-cmd --list-all
  sudo firewall-cmd --get-active-zones

# List interfaces that are bound to a zone
[group('Firewall')]
show-interfaces:
  sudo firewall-cmd --list-interfaces

# Display information for a service
[group('Firewall')]
show-service service:
  sudo firewall-cmd --info-service={{ service }}

# Display predefined services
[group('Firewall')]
show-services:
  sudo firewall-cmd --get-services

# Display the zone for an interface
[group('Firewall')]
show-zone-for-interface interface:
  sudo firewall-cmd --get-zone-of-interface={{ interface }}