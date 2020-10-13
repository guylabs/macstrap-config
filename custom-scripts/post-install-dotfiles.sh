#!/bin/sh
set -e

# Symlink all the dotfiles and folders to the home directory
for item in $macstrapConfigFolder/configs/dotfiles/{.config,.gnupg,.ssh,.vim,init,.editorconfig,.gitconfig,.inputrc,.profile,.vimrc,.zshrc}; do
    if test  -d "$item"; then
        symlinkDirectory "$item" "$HOME/$(basename "$item")"
    fi

    if test -f "$item"; then
        symlinkFile "$item" "$HOME/$(basename "$item")"
    fi
done
