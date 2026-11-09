# ~/.bashrc.d/functions.sh
#
# Custom shell functions, sourced by ~/.bashrc.
#
# Files in this directory are sourced in alphabetical order;
# no shebang is required. After editing, run `source ~/.bashrc`
# to apply changes to the current session.

# tree — show a directory tree, falling back to an ephemeral container
# (via `just tree`) if the `tree` binary is not installed locally.
tree() {
  if command -v tree >/dev/null 2>&1; then
    command tree "$@"
  else
    just tree "$@"
  fi
}
