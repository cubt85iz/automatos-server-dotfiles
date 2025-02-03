set ignore-comments := true

[private]
default:
  @just -l

follow-logs service:
  journalctl -fxeu {{ service }}

show-logs service:
  journalctl -xeu {{ service }}

