#!/usr/bin/env bash
set -euo pipefail

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
brew cask upgrade

# update App Store apps
if test $(hash mas); then
  echo -e "Updating App Store apps ..."
  echo
  mas upgrade
fi

# cleanup
echo -e "Cleaning up homebrew ..."
echo
brew cleanup
