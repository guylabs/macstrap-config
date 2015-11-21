#!/usr/bin/env bash
set -e

# Symlink the .gitconfig configuration file
if [[ ! -e "$HOME/.gitconfig" ]]; then
  ln -s "$macstrapConfigFolder/configs/macstrap/git-config" "$HOME/.gitconfig"
  echo -e "Symlinked \033[1m$macstrapConfigFolder/configs/macstrap/git-config\033[0m => \033[1m$HOME/.gitconfig\033[0m"
else
  echo -e "\033[0;33mWARN: \033[1m$HOME/.gitconfig\033[0m already exists. Please remove it and install again.\033[1;34m"
fi