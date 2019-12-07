#!/bin/sh
set -e

# Unlink the already installed postgresql on CI.
if [ -n "$CI" ]; then
  brew uninstall --ignore-dependencies postgresql
fi

# Tap versioned PostgreSQL repository see https://github.com/petere/homebrew-postgresql
brew tap petere/postgresql

# Fix https://github.com/petere/homebrew-postgresql/issues/44 by removing the --with-perl option
sed -i "" "/--with-perl/d" /usr/local/Homebrew/Library/Taps/petere/homebrew-postgresql/postgresql@11.rb

# Install the latest PostgreSQL 11.x
brew install petere/postgresql/postgresql-common petere/postgresql/postgresql@11

# Create the main cluster and the default postgres user
pg_createcluster --locale en_US -e UTF-8 --start 11 main -- --auth=trust
psql -d postgres -c 'CREATE USER postgres SUPERUSER;'

# Fix https://github.com/petere/homebrew-postgresql/issues/49 by creating the folder before starting the cluster
alias startpostgres="mkdir /usr/local/etc/postgresql/11/main/conf.d || pg_ctlcluster 11 main start"
