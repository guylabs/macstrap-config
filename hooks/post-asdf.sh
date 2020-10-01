#!/bin/sh
set -e

# Install ASDF Java plugin
asdf plugin add java

# Install Java 8
asdf install java adoptopenjdk-8.0.265+1

# Install Java 11 and set it globally as default
asdf install java adoptopenjdk-11.0.8+10
asdf global java adoptopenjdk-11.0.8+10

# Install Java 15
asdf install java adoptopenjdk-15.0.0+36 

# Install ASDF NodeJS plugin
asdf plugin add nodejs
${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring

# Install NodeJS 12.13.1 and set it globally as default
asdf install nodejs 12.13.1
asdf global nodejs 12.13.1
