#!/usr/bin/env bash
set -e

# Show banner
echo
echo -e "#########################"
echo -e "# Installing system ... #"
echo -e "#########################"
echo

# installs the apps and binaries with the according hooks
installAppOrBinary() {
  _array=( "$1" )
  for item in ${_array[@]}
  do
    # execute the pre scripts
    preScript="$macstrapConfigFolder/hooks/pre-$item.sh"
    if [ -e $preScript ]; then
      echo
      echo -e "Executing \033[1m$preScript\033[0m ..."
      echo
      bash $preScript
    fi

    # install the app or binary
    if [ $2 = "cask" ]; then
        brew cask install $item
    else
        brew install $item
    fi

    # execute the post scripts
    postScript="$macstrapConfigFolder/hooks/post-$item.sh"
    if [ -e $postScript ]; then
      echo
      echo -e "Executing \033[1m$postScript\033[0m ..."
      echo
      bash $postScript
    fi

  done
}

# Update homebrew
echo -e "Updating homebrew ..."
echo
brew update

# Source the configuration file
source $macstrapConfigFile

# Install apps
if [ ${#apps} -gt 0 ]; then
    echo -e "Installing apps ..."
    installAppOrBinary "$(echo ${apps[@]})" "cask"
else
    echo -e "No apps defined in macstrap configuration."
fi

# Install binaries
if [ ${#binaries} -gt 0 ]; then
    echo -e "Installing binaries ..."
    installAppOrBinary "$(echo ${binaries[@]})"
else
    echo -e "No binaries defined in macstrap configuration."
fi

# Remove outdated versions from the cellar
echo -e "Cleanup homebrew and homebrew cask ..."
echo
brew cleanup
brew cask cleanup

