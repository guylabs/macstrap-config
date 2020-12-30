#!/bin/sh
set -e

# Ensure GPG is installed as the NodeJS installation requires it
brew install gpg

# Install ASDF Java plugin
asdf plugin add java || true

# Install Java 8
asdf install java adoptopenjdk-8.0.265+1 || true

# Install Java 11 and set it globally as default
asdf install java adoptopenjdk-11.0.8+10 || true
asdf global java adoptopenjdk-11.0.8+10 || true

# Install Java 15
asdf install java adoptopenjdk-15.0.0+36 || true

# Install ASDF NodeJS plugin
asdf plugin add nodejs || true
${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring

# Install NodeJS 12.13.1 and set it globally as default
asdf install nodejs 12.13.1 || true
asdf global nodejs 12.13.1 || true
