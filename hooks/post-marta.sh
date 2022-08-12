#!/bin/sh
set -e

# symlink a directory if it does not exist
symlinkDirectory() {
  if [ ! -d "$2" ]; then
    ln -s "$1" "$2"
    printf "Symlinked directory from \033[1m%s\033[0m to \033[1m%s\033[0m\n" "$1" "$2"
  else
    printf "Could not symlink directory from \033[1m%s\033[0m to \033[1m%s\033[0m as it already exists.\n" "$1" "$2"
    renameSymlink "$1" "$2"
  fi
}

#symlinkDirectory "$macstrapConfigFolder/configs/marta" "$HOME/Library/Application Support/org.yanex.marta"
symlinkDirectory "$HOME/.macstrap/configs/marta" "$HOME/Library/Application Support/org.yanex.marta"