#!/bin/sh
set -e

export JENV_ROOT=/usr/local/opt/jenv

# Install jEnv
if hash jenv > /dev/null; then
  eval "$(jenv init -)"

  # Add Java 8
  jenv add "$(/usr/libexec/java_home -v 1.8)"

  # Add Java 11
  jenv add "$(/usr/libexec/java_home -v 11)"

  # Add Java 12
  jenv add "$(/usr/libexec/java_home -v 12)"

  # Enable export plugin for JAVA_HOME
  jenv sh-enable-plugin export

else
  echo "\033[0;33mWARN: jEnv not installed as the jenv is present already.\033[1;34m"
fi
