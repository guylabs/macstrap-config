#!/usr/bin/env bash
set -e

brew services start postgresql

sleep 5

psql -d postgres -c 'CREATE USER postgres SUPERUSER;'
psql -d postgres -c 'GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;'
