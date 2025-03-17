# Follow logs displayed for specified service
[group('Logging')]
follow-logs service:
  @journalctl -fxeu {{ service }}

# Show logs for specified service
[group('Logging')]
show-logs service:
  @journalctl -xeu {{ service }} -n 30000

