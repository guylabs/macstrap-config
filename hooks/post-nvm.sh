#!/bin/sh
set -e

if [ ! -d "$HOME/.nvm" ]; then
    mkdir "$HOME/.nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    nvm install 12.13.1
fi
