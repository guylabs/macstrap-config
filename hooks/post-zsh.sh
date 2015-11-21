#!/usr/bin/env bash
set -e

# Symlink the .bash_profile configuration file
if [[ ! -e "$HOME/.bash_profile" ]]; then
  ln -s "$macstrapConfigFolder/configs/macstrap/profile.sh" "$HOME/.bash_profile"
  echo -e "Symlinked \033[1m$macstrapConfigFolder/configs/macstrap/profile.sh\033[0m => \033[1m$HOME/.bash_profile\033[0m"
else
  echo -e "\033[0;33mWARN: \033[1m$HOME/.bash_profile\033[0m already exists. Please remove it and install again.\033[1;34m"
fi

# Symlink the .zshrc configuration file
if [[ ! -e "$HOME/.zshrc" ]]; then
  ln -s "$macstrapConfigFolder/configs/macstrap/profile.sh" "$HOME/.zshrc"
  echo -e "Symlinked \033[1m$macstrapConfigFolder/configs/macstrap/profile.sh\033[0m => \033[1m$HOME/.zshrc\033[0m"
else
  echo -e "\033[0;33mWARN: \033[1m$HOME/.zshrc\033[0m already exists. Please remove it and install again.\033[1;34m"
fi

# Install oh-my-zsh
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash
rm -rf ~/.zshrc
mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc