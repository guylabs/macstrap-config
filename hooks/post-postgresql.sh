#!/usr/bin/env bash
set -e

# initialize the database and start the server (enable autostart on login as well)
initdb `brew --prefix`/var/postgres -E UTF-8 -U postgres --lc-collate en_US.UTF-8
brew services start postgresql