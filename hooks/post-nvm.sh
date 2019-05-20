#!/usr/bin/env bash
set -eo pipefail

if [ ! -d "$HOME/.nvm" ]; then
    mkdir "$HOME/.nvm"
    export NVM_DIR="$HOME/.nvm"
    [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
    [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"
    nvm install 10.4.1
fi