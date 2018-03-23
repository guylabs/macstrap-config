#!/usr/bin/env bash
set -e

# initialize the database and start the server (enable autostart on login as well)
DB_FOLDER=`brew --prefix`/var/postgres
if [[ ! -e $DB_FOLDER ]]; then
    initdb $DB_FOLDER -E UTF-8 -U postgres --lc-collate en_US.UTF-8
fi
brew services start postgresql