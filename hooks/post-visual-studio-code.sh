#!/bin/sh
set -e

# Disbale Gatekeeper to be allow installation of extensions
sudo spctl --master-disable

# Install the extensions
code --force --install-extension marvinhagemeister.theme-afterglow-remastered
code --force --install-extension joaompinto.asciidoctor-vscode
code --force --install-extension k--kato.intellij-idea-keybindings
code --force --install-extension mathiasfrohlich.kotlin
code --force --install-extension dotjoshjohnson.xml

# Enable Gatekeeper again
sudo spctl --master-enable
