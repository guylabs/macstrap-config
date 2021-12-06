#!/bin/sh
set -e

# Read input and use given default when executed in CI
readInput() {
  local input="$1"
  if [ -z "${CI-}" ]; then
    read -r input
  fi
  echo "$input"
}

# Show banner
echo
echo "##############################"
echo "# Installing your system ... #"
echo "##############################"
echo
printf "Please follow the installation process and enter the necessary information when prompted. Press Enter to continue."
readInput

# Enable full disk access for the Terminal app to set all required settings. Only do this if not on CI
if [ -z "${CI-}" ]; then
  sqlite3 /Library/Application\ Support/com.apple.TCC/TCC.db 'select * from access' > /dev/null 2>&1 && hasFullFileAccess=true || hasFullFileAccess=false

  if [ "$hasFullFileAccess" = "false" ]; then
    printf "\033[1mPlease give the Terminal app full disk access by configuring it on the Security/Privacy tab.\033[0m\n"
    printf "\033[1mThe security preferences will open after you press Enter. Please restart the Terminal app and execute the installation again.\033[0m\n"
    readInput
    open /System/Library/PreferencePanes/Security.prefPane
    exit 0
  fi

  # Check if we need to install Rosetta 2 on ARM architecture
  if isArmArchitecture; then
      softwareupdate --install-rosetta --agree-to-license
  fi
fi

# installs the app or binary with the according hooks
installAppOrBinary() {
  if isFormulaInstalled "$1" "$2"; then
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
      brew install -f --cask "$1"
    else
      brew install -f "$1" \
        || brew upgrade "$1" \
        || (printf "\n\e[1;31m%s could neither be installed nor upgraded by brew.\e[m\n\n" "$1"; exit 1)
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
  fi
}

# check if formula is already installed
isFormulaInstalled() {
  if [ "$2" = "cask" ]; then
    if brew ls --cask --full-name "$1"; then
      printf "- Cask formula %s already installed." "$1"
      return 0
    fi
  else
    if brew ls --full-name "$1"; then
    printf "- Formula %s already installed." "$1"
      return 0
    fi
  fi
  return 1
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
