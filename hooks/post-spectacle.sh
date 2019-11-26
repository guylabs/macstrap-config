#!/bin/sh
set -euo

mkdir -p "$HOME/Library/Application Support/Spectacle"
symlinkFile "$macstrapConfigFolder/configs/spectacle/Shortcuts.json" "$HOME/Library/Application Support/Spectacle/Shortcuts.json"
