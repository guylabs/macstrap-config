#!/bin/sh
set -e

if [ -z "$CI" ]; then
  if ! sudo fdesetup status | grep -q 'FileVault is On.'; then
    echo "Please enable FileVault disk encryption and rerun the macstrap install."
    exit 1
  fi
fi
