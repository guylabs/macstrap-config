#!/usr/bin/env bash
set -e

# Show banner
echo
echo -e "###########################"
echo -e "# Updating the system ... #"
echo -e "###########################"
echo

# update OS X software packages
echo -e "Updating the OS X app store applications ..."
echo
softwareupdate -ia

# update brew and cask packages
echo -e "Updating the apps and binaries ..."
echo
brew update
brew upgrade
brew upgrade brew-cask || true

# update atom packages
if test $(which apm); then
  echo -e "Updating atom packages ..."
  echo
  apm upgrade
fi

# update npm packages
if test $(which npm); then
  echo -e "Updating npm global packages ..."
  echo
  npm update -g
fi

# update nvm
if test $(which nvm); then
  echo -e "Updating NVM ..."
  echo
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
fi

# update jEnv
if test $(which jenv); then
  echo -e "Updating jEnv ..."
  echo
  cd ~/.jenv/ && git pull
fi

# update oh-my-zsh
if test $(which upgrade_oh_my_zsh); then
  echo -e "Updating oh-my-zsh ..."
  echo
  upgrade_oh_my_zsh
fi

# cleanup
echo -e "Cleaning up homebrew ..."
echo
brew cleanup
brew cask cleanup
