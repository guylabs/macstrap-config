#!/usr/bin/env bash
set -euo pipefail

export JENV_ROOT=/usr/local/opt/jenv

# Install jEnv
if hash jenv > /dev/null; then
  eval "$(jenv init -)"

  # Add Java 6
  jenv add $(/usr/libexec/java_home -v 1.6)

  # Add Java 8
  jenv add $(/usr/libexec/java_home -v 1.8)

  # Add Java 11
  jenv add $(/usr/libexec/java_home -v 11)

  # Add Java 12
  jenv add $(/usr/libexec/java_home -v 12)

  # Set the Java 8 as global Java
  jenv global 1.8

else
  echo -e "\033[0;33mWARN: jEnv not installed as the ~/.jenv folder is already present.\033[1;34m"
fi
