#!/bin/sh
set -e

# Show banner
echo
echo "##############################"
echo "# Installing your system ... #"
echo "##############################"
echo

# installs the app or binary with the according hooks
installAppOrBinary() {
  # execute the pre scripts
  preScript="$macstrapConfigFolder/hooks/pre-$1.sh"
  if [ -e "$preScript" ]; then
    echo
    echo "Executing \033[1m$preScript\033[0m ..."
    echo
    # shellcheck source=preScript.sh
    . "$preScript"
  fi

  # install the app or binary
  if [ "$2" = "cask" ]; then
      brew cask install "$1"
  elif [ "$2" = "appStore" ]; then
      mas install "$1"
  else
      brew install "$1"
  fi

  # execute the post scripts
  postScript="$macstrapConfigFolder/hooks/post-$1.sh"
  if [ -e "$postScript" ]; then
    echo
    echo "Executing \033[1m$postScript\033[0m ..."
    echo
    # shellcheck source=postScript.sh
    . "$postScript"
  fi
}

# rename symlink
renameSymlink() {
  if [ ! -L "$2" ]; then
    mv "$2" "$2.backup"
    ln -s "$1" "$2"
    echo "  - Renamed it to \033[1m$2.backup\033[0m"
  fi
}

# symlink a file if it does not exist
symlinkFile() {
  if [ ! -e "$2" ]; then
    ln -s "$1" "$2"
    echo "Symlinked file from \033[1m$1\033[0m to \033[1m$2\033[0m"
  else
    echo "Could not symlink file from \033[1m$1\033[0m to \033[1m$2\033[0m as it already exists."
    renameSymlink "$1" "$2"
  fi
}

# symlink a directory if it does not exist
symlinkDirectory() {
  if [ ! -d "$2" ]; then
    ln -s "$1" "$2"
    echo "Symlinked directory from \033[1m$1\033[0m to \033[1m$2\033[0m"
  else
    echo "Could not symlink directory from \033[1m$1\033[0m to \033[1m$2\033[0m as it already exists."
    renameSymlink "$1" "$2"
  fi
}

# Update homebrew
echo "Updating homebrew ..."
echo
brew update

# Source the configuration file
# shellcheck source=macstrapConfigFile.sh
. "$macstrapConfigFile"

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

# The installation of mas can be skipped. This is used in CI environments where there is no possibility to login to the app store manually.
if [ -z "$CI" ]; then

    # Install mas - https://github.com/mas-cli/mas
    brew install mas

    echo
    echo "Please manually sign in into the App Store to be able to install the App Store apps. When done, press Enter to continue..."
    read -r

fi

# Install App Store apps
if [ "${#appStoreApps[@]}" -gt 0  ]; then
    echo "Installing App Store apps ..."
    for item in "${appStoreApps[@]}"
    do
      installAppOrBinary "$item" "appStore"
    done
else
    echo "No App Store apps defined in macstrap configuration."
fi

# Remove outdated versions from the cellar
echo "Cleanup homebrew and homebrew cask ..."
echo
brew cleanup
