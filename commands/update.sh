#!/bin/sh
set -e

# Show banner
echo
echo "###########################"
echo "# Updating the system ... #"
echo "###########################"
echo

# update OS X software packages
echo "Updating the OS X app store applications ..."
echo
softwareupdate -ia

# update brew and cask packages
echo "Updating the apps and binaries ..."
echo
brew update
brew upgrade
brew cask upgrade

# update App Store apps
if test "$(hash mas)"; then
  echo "Updating App Store apps ..."
  echo
  mas upgrade
fi

# cleanup
echo "Cleaning up homebrew ..."
echo
brew cleanup
