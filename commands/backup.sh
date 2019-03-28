#!/usr/bin/env bash
set -euo pipefail

echo -e "Backing up configuration with mackup..."
mackup backup
