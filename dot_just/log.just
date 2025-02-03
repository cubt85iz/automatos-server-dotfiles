# Follow logs displayed for specified service
follow-logs service:
  journalctl -fxeu {{ service }}

# Show logs for specified service
show-logs service:
  journalctl -xeu {{ service }}

