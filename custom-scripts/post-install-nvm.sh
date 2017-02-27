#!/usr/bin/env bash
set -e

# Source the configuration file
source $macstrapConfigFile

# Install nvm
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install stable
  nvm alias default stable
else
  echo -e "\033[0;33mWARN: NVM not installed as the ~/.nvm folder is already present.\033[1;34m"
fi

# Install NPM packages
if [ ${#globalNpmPackages} -gt 0 ]; then
    echo -e "Installing global NPM packages within the NVM default..."
    npm install -g ${globalNpmPackages[@]}
else
    echo -e "No global NPM packages defined in macstrap configuration."
fi