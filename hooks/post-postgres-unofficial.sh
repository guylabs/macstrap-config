#!/bin/sh
set -e

# Enable CLI tools for Postgres app
sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

echo "Please follow these steps once the Postgres app is started after pressing Enter:"
echo "1. Remove any default Postgres servers and initialize/add a new Postgres 12 server on port 5432."
echo "2. Ensure on the server settings section that the 'Automatically start server' checkbox is checked"
echo
echo "Press Enter to continue and start the Postgres app."
readInput

open -a Postgres

echo "IMPORTANT: Ensure that you setup a Postgres 12 server and not the default version which is higher than 12. See above how to set it up. Once done, press Enter to continue the installation."
readInput
