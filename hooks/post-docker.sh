#!/bin/sh
set -e

echo "The Docker app will be started such that you can configure the necessary permissions and finalize the installation."
echo "Press Enter to continue."
readInput

# Open Docker to set proper permissions and have it running after the installation
open -a Docker
