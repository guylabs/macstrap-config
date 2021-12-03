#!/bin/sh
set -e

# Enable CLI tools for Postgres app
sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

echo "The Postgress app will be started. Remove any default Postgres servers and initialize a Postgres 12 server on port 5432. Ensure on the server settings that the server starts automatically after a restart."
echo "Press Enter to continue."
readInput

open -a Postgres

echo "Once the Postgres server is running, press Enter to continue the installation."
readInput
