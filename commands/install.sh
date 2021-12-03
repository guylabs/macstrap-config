#!/bin/sh
set -e

# Evaluate brew when the terminal is restarted
if test ! "$(hash brew)"; then
  # If M1 Mac
  if [[ `uname -m` == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(brew --prefix)/bin/brew shellenv"
  fi
fi

# Update homebrew
echo "Updating homebrew ..."
echo
brew update

# Source the configuration file
# shellcheck source=macstrapConfigFile.sh
. "$macstrapConfigFile"

# Install binaries
if [ "${#binaries[@]}" -gt 0 ]; then
    echo "Installing binaries ..."
    for item in "${binaries[@]}"
    do
      installAppOrBinary "$item" ""
    done
else
    echo "No binaries defined in macstrap configuration."
fi

# Install apps
if [ "${#apps[@]}" -gt 0 ]; then
    echo "Installing apps ..."
    for item in "${apps[@]}"
    do
      installAppOrBinary "$item" "cask"
    done
else
    echo "No apps defined in macstrap configuration."
fi

# Remove outdated versions from the cellar
echo "Cleanup homebrew and homebrew cask ..."
echo
brew cleanup
brew autoremove
