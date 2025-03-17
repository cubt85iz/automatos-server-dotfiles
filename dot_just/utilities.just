# Adds all recipes to .bashrc.d file
[group('Utilities')]
add-aliases-for-recipes:
  #!/usr/bin/env bash

  set -euo pipefail

  FILE=$HOME/.bashrc.d/just-aliases.sh

  # Remove and recreate shell script
  [ ! -f "$FILE" ] || rm "$FILE"
  echo "#!/usr/bin/env bash" > "$FILE"
  echo "" >> "$FILE"  

  # Read into RECIPES array
  read -a RECIPES <<< $(just --summary)

  # Iterate over recipes and create aliases for each.
  for RECIPE in ${RECIPES[@]}; do
    if [ "$RECIPE" != "add-aliases-for-recipes" ]; then
      echo "alias $RECIPE='just $RECIPE'" >> $HOME/.bashrc.d/just-aliases.sh
    fi
  done

  just "Aliases added for just recipes. Execute 'source $HOME/.bashrc.d/just-aliases.sh' to use them now."
