#!/usr/bin/env bash
set -e

# Source the configuration file
source $macstrapConfigFile

# Install atom packages
if [ ${#atomPackages} -gt 0 ]; then
    echo -e "Installing atom packages ..."
    apm install ${atomPackages[@]}
else
    echo -e "No atom packages defined in $macstrapConfigFolder/macstrap.cfg"
fi