#!/bin/sh
set -e

# Ensure GPG is installed as the NodeJS installation requires it
brew install gpg

# Install ASDF Java plugin
asdf plugin add java || true

# Install Java 7
asdf install java zulu-7.44.0.11 || true

# Install Java 8
asdf install java adoptopenjdk-8.0.282+8 || true

# Install Java 11 and set it globally as default
asdf install java adoptopenjdk-11.0.10+9 || true
asdf global java adoptopenjdk-11.0.10+9 || true

# Install Java 16
asdf install java adoptopenjdk-16.0.0+36 || true

# Install ASDF NodeJS plugin
asdf plugin add nodejs || true
${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring

# Install NodeJS 14.16.0 and set it globally as default
asdf install nodejs 14.16.0 || true
asdf global nodejs 14.16.0 || true
