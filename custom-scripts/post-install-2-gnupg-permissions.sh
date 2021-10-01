#!/bin/sh
set -e

# Set correct persimissions so that gnupg doesn't complain
# use -L in find to follow symlinks, since macstrap symlinks the folder to somewhere else
find -L ~/.gnupg -type f -exec chmod 600 {} \; # Set 600 for files
find -L ~/.gnupg -type d -exec chmod 700 {} \; # Set 700 for directories