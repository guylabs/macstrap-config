#!/bin/sh
set -e

# Ensure GPG is installed as the NodeJS installation requires it
brew install gpg

# Install ASDF Java plugin
asdf plugin add java || true

# Install Java 8
asdf install java liberica-8u312+7 || true

# Install Java 11 and set it globally as default
asdf install java liberica-11.0.13+8 || true
asdf global java liberica-11.0.13+8 || true

# Install Java 16
asdf install java liberica-16.0.2+7 || true

# Install Java 17
asdf install java liberica-17.0.1+12 || true

# Install ASDF NodeJS plugin
asdf plugin add nodejs || true

# Install NodeJS 17.0.1 and set it globally as default
asdf install nodejs 17.0.1 || true
asdf global nodejs 17.0.1 || true
