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
brew upgrade --greedy

# cleanup
echo "Cleaning up homebrew ..."
echo
brew autoremove
brew cleanup

# update asdf
echo "Updating ASDF plugins ..."
echo
asdf plugin update --all
