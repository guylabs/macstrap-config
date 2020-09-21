#!/bin/sh
set -e

# Show banner
echo
echo "##############################"
echo "# Installing your system ... #"
echo "##############################"
echo

# Enable full disk access for the Terminal app to set all required settings. Only do this if not on CI
if [ -z "$CI" ]; then
  sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db 'select * from access' > /dev/null 2>&1 && hasFullFileAccess=true || hasFullFileAccess=false

  if [ "$hasFullFileAccess" = "false" ]; then
    printf "\033[1mPlease give the Terminal app full disk access by configuring it on the Security/Privacy tab.\033[0m\n"
    printf "\033[1mThe security preferences will open after you press Enter. Please restart the Terminal app and execute the installation again.\033[0m\n"
    read -r
    open /System/Library/PreferencePanes/Security.prefPane
    exit 0
  fi
fi

# installs the app or binary with the according hooks
installAppOrBinary() {
  # execute the pre scripts
  preScript="$macstrapConfigFolder/hooks/pre-$1.sh"
  if [ -e "$preScript" ]; then
    echo
    printf "Executing \033[1m%s\033[0m ...\n" "$preScript"
    echo
    # shellcheck source=preScript.sh
    . "$preScript"
  fi

  # install the app or binary
  if [ "$2" = "cask" ]; then
      brew cask install "$1"
  else
      brew install "$1"
  fi

  # execute the post scripts
  postScript="$macstrapConfigFolder/hooks/post-$1.sh"
  if [ -e "$postScript" ]; then
    echo
    printf "Executing \033[1m%s\033[0m ...\n" "$postScript"
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
    printf "  - Renamed it to \033[1m%s.backup\033[0m\n" "$2"
  fi
}

# symlink a file if it does not exist
symlinkFile() {
  if [ ! -e "$2" ]; then
    ln -s "$1" "$2"
    printf "Symlinked file from \033[1m%s\033[0m to \033[1m%s\033[0m\n" "$1" "$2"
  else
    printf "Could not symlink file from \033[1m%s\033[0m to \033[1m%s\033[0m as it already exists.\n" "$1" "$2"
    renameSymlink "$1" "$2"
  fi
}

# symlink a directory if it does not exist
symlinkDirectory() {
  if [ ! -d "$2" ]; then
    ln -s "$1" "$2"
    printf "Symlinked directory from \033[1m%s\033[0m to \033[1m%s\033[0m\n" "$1" "$2"
  else
    printf "Could not symlink directory from \033[1m%s\033[0m to \033[1m%s\033[0m as it already exists.\n" "$1" "$2"
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

# Remove outdated versions from the cellar
echo "Cleanup homebrew and homebrew cask ..."
echo
brew cleanup
