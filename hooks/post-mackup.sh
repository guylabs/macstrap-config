#!/usr/bin/env bash
set -e

if [ ! -e "$HOME/.mackup.cfg" ]; then
  cp -rn "$macstrapConfigFolder/configs/mackup/.mackup.cfg" "$HOME/.mackup.cfg"
  echo -e "Copied the skeleton mackup configuration to \033[1m$HOME/.mackup.cfg\033[0m"
fi
if [ ! -d "$HOME/.mackup" ]; then
  cp -rn "$macstrapConfigFolder/configs/mackup/conf" "$HOME/.mackup"
  echo -e "Copied the additional mackup configurations to \033[1m$HOME/.mackup\033[0m"
fi