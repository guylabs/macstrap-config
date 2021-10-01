#!/bin/sh
set -e

# Enable CLI tools for Postgres app
sudo mkdir -p /etc/paths.d && echo /Applications/Postgres.app/Contents/Versions/latest/bin | sudo tee /etc/paths.d/postgresapp

echo "The Postgress app will be started and then please initialize the server for Postgres version 12 on port 5432."
echo "Press Enter to continue."
readInput

open -a Postgres

echo "Once the Postgres server is running, press Enter to continue the installation."
readInput
