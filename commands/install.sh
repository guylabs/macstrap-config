#!/usr/bin/env bash
set -e

# Show banner
echo
echo -e "##############################"
echo -e "# Installing your system ... #"
echo -e "##############################"
echo

# installs the app or binary with the according hooks
installAppOrBinary() {
  # execute the pre scripts
  preScript="$macstrapConfigFolder/hooks/pre-$1.sh"
  if [ -e "$preScript" ]; then
    echo
    echo -e "Executing \033[1m$preScript\033[0m ..."
    echo
    source $preScript
  fi

  # install the app or binary
  if [ "$2" = "cask" ]; then
      brew cask install $1
  elif [ "$2" = "appStore" ]; then
      mas install $1
  else
      brew install $1
  fi

  # execute the post scripts
  postScript="$macstrapConfigFolder/hooks/post-$1.sh"
  if [ -e "$postScript" ]; then
    echo
    echo -e "Executing \033[1m$postScript\033[0m ..."
    echo
    source $postScript
  fi
}

# rename symlink
renameSymlink() {
  if [ ! -L "$2" ]; then
    mv "$2" "$2.backup"
    ln -s "$1" "$2"
    echo -e "  - Renamed it to \033[1m$2.backup\033[0m"
  fi
}

# symlink a file if it does not exist
symlinkFile() {
  if [ ! -e "$2" ]; then
    ln -s "$1" "$2"
    echo -e "Symlinked file from \033[1m$1\033[0m to \033[1m$2\033[0m"
  else
    echo -e "Could not symlink file from \033[1m$1\033[0m to \033[1m$2\033[0m as it already exists."
    renameSymlink "$1" "$2"
  fi
}

# symlink a directory if it does not exist
symlinkDirectory() {
  if [ ! -d "$2" ]; then
    ln -s "$1" "$2"
    echo -e "Symlinked directory from \033[1m$1\033[0m to \033[1m$2\033[0m"
  else
    echo -e "Could not symlink directory from \033[1m$1\033[0m to \033[1m$2\033[0m as it already exists."
    renameSymlink "$1" "$2"
  fi
}

# Update homebrew
echo -e "Updating homebrew ..."
echo
brew update

# Source the configuration file
source $macstrapConfigFile

# Install apps
if [[ ${apps[@]:+${apps[@]}} ]]; then
    echo -e "Installing apps ..."
    for item in "${apps[@]}"
    do
      installAppOrBinary "$item" "cask"
    done
else
    echo -e "No apps defined in macstrap configuration."
fi

# Install binaries
if [[ ${binaries[@]:+${binaries[@]}} ]]; then
    echo -e "Installing binaries ..."
    for item in "${binaries[@]}"
    do
      installAppOrBinary "$item" ""
    done
else
    echo -e "No binaries defined in macstrap configuration."
fi

# Install mas - https://github.com/mas-cli/mas
brew install mas

echo
echo -e "Please manually sign in into the App Store to be able to install the App Store apps. When done, press Enter to continue..."
read -e

# Install App Store apps
if [[ ${appStoreApps[@]:+${appStoreApps[@]}} ]]; then
    echo -e "Installing App Store apps ..."
    for item in "${appStoreApps[@]}"
    do
      installAppOrBinary "$item" "appStore"
    done
else
    echo -e "No App Store apps defined in macstrap configuration."
fi

# Remove outdated versions from the cellar
echo -e "Cleanup homebrew and homebrew cask ..."
echo
brew cleanup
