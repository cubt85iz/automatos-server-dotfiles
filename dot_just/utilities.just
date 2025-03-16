import "shared.just"

# Adds all recipes to .bashrc.d file
[group('Utilities')]
add-aliases-for-recipes:
  #!/usr/bin/env bash

  set -euo pipefail

  just --summary | read -a RECIPES

  # Remove and recreate shell script
  rm $HOME/.bashrc.d/just-aliases.sh
  cat > $HOME/.bashrc.d/just-aliases.sh <<EOF
#!/usr/bin/env bash

EOF
  
  for RECIPE in ${RECIPES[@]}; do
    if [ "$RECIPE" != "add-aliases-for-recipes" ]; then
      echo "alias $RECIPE='just $RECIPE'" > $HOME/.bashrc.d/just-aliases.sh
  done

  just -f "{{ justfile() }}" stdout "Aliases added for just recipes. Execute `source $HOME/.bashrc.d/just-aliases.sh` to use them now."
