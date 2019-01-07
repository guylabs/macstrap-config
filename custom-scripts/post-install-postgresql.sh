#!/usr/bin/env bash
set -e

# Tap versioned PostgreSQL repository see https://github.com/petere/homebrew-postgresql
brew tap petere/postgresql

# Install the latest PostgreSQL 10.x
brew install petere/postgresql/postgresql-common petere/postgresql/postgresql@10

# Create the main cluster and the default postgres user
pg_createcluster --locale en_US -e UTF-8 --start 10 main -- --auth=trust
psql -d postgres -c 'CREATE USER postgres SUPERUSER;'
