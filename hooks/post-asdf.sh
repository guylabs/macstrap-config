#!/bin/sh
set -e

# Ensure GPG is installed as the NodeJS installation requires it
brew install gpg

# Install ASDF Java plugin
asdf plugin add java || true

# Install Java 7
asdf install java zulu-7.48.0.11 || true

# Install Java 8
asdf install java temurin-8.0.302+8 || true

# Install Java 11 and set it globally as default
asdf install java temurin-11.0.12+7 || true
asdf global java temurin-11.0.12+7 || true

# Install Java 16
asdf install java temurin-16.0.2+7 || true

# Install ASDF NodeJS plugin
asdf plugin add nodejs || true
${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring

# Install NodeJS 16.3.0 and set it globally as default
asdf install nodejs 16.3.0 || true
asdf global nodejs 16.3.0 || true
