#!/usr/bin/env bash
set -e

shopt -s dotglob

# Symlink all the dotfiles and folders to the home directory
for item in $macstrapConfigFolder/configs/dotfiles/*; do
    if test  -d "$item"; then
        symlinkDirectory $item "$HOME/$(basename $item)"
    fi

    if test -f "$item"; then
        symlinkFile $item "$HOME/$(basename $item)"
    fi
done
