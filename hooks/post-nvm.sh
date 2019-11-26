#!/bin/sh
set -eo

if [ ! -d "$HOME/.nvm" ]; then
    mkdir "$HOME/.nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    nvm install 10.4.1
fi