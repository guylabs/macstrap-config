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
brew cask upgrade --greedy

# cleanup
echo "Cleaning up homebrew ..."
echo
brew cleanup
