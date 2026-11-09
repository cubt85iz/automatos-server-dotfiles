# ~/.bashrc.d/03-starship.sh
#
# Starship prompt initialization.
# Sourced automatically by ~/.bashrc if the starship binary is installed.

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

