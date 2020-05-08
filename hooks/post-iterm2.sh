#!/bin/sh
set -e

# Specify the iTerm2 preferences directory
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$macstrapConfigFolder/configs/iterm"

# Tell iTerm2 to use the custom preferences in the directory
defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
