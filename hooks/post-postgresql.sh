#!/usr/bin/env bash
set -e

brew services start postgresql

psql -d postgres -c 'CREATE USER postgres SUPERUSER;'
psql -d postgres -c 'GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;'
