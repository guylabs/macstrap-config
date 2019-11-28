#!/bin/sh
set -e

mkdir -p "$HOME/Library/Application Support/Spectacle"
symlinkFile "$macstrapConfigFolder/configs/spectacle/Shortcuts.json" "$HOME/Library/Application Support/Spectacle/Shortcuts.json"
