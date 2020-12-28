#!/bin/sh
set -e

# Affinity app
open https://apps.apple.com/us/app/lastpass/id824183456

# Show notification to install the apps
osascript -e 'display notification "Please install these App Store apps" with title "Install App Store apps"'