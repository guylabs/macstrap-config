#!/bin/sh
set -e

# Unlink the already installed postgresql on CI.
if [ -n "$CI" ]; then
  brew uninstall --ignore-dependencies postgresql
fi

# Tap versioned PostgreSQL repository see https://github.com/petere/homebrew-postgresql
brew tap petere/postgresql

# Install the latest PostgreSQL 11.x
brew install petere/postgresql/postgresql-common petere/postgresql/postgresql@11

# Create the main cluster and the default postgres user
pg_createcluster --locale en_US -e UTF-8 --start 11 main -- --auth=trust
psql -d postgres -c 'CREATE USER postgres SUPERUSER;'
