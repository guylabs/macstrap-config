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

# update App Store apps
if test $(which mas); then
  echo -e "Updating App Store apps ..."
  echo
  mas upgrade
fi

# cleanup
echo -e "Cleaning up homebrew ..."
echo
brew cleanup
brew cask cleanup
