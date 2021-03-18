#!/bin/sh
set -e

# Unlink the already installed postgresql on CI.
if [ -n "$CI" ]; then
  brew uninstall --ignore-dependencies postgresql
fi

# Tap versioned PostgreSQL repository see https://github.com/petere/homebrew-postgresql
brew tap petere/postgresql

# Fix https://github.com/petere/homebrew-postgresql/issues/44 by removing the --with-perl option
sed -i "" "/--with-perl/d" $(brew --repo)/Library/Taps/petere/homebrew-postgresql/postgresql@12.rb

# Install the latest PostgreSQL 12.x
brew install petere/postgresql/postgresql-common petere/postgresql/postgresql@12

# Create the main cluster and the default postgres user
pg_createcluster --locale en_US -e UTF-8 --start 12 main -- --auth=trust
psql -d postgres -c 'CREATE USER postgres SUPERUSER;'
