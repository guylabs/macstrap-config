#!/usr/bin/env bash
set -euo pipefail

echo -e "Restoring configuration with mackup..."
mackup restore
