#!/usr/bin/env bash
set -e

  export JENV_ROOT=/usr/local/opt/jenv
# Install jEnv
if which jenv > /dev/null; then
  eval "$(jenv init -)"

  # Add Java 8
  jenv add $(/usr/libexec/java_home -v 1.8)

  # Set the Java 9 as global Java
  jenv add $(/usr/libexec/java_home -v 9)
  jenv global 9.0

else
  echo -e "\033[0;33mWARN: jEnv not installed as the ~/.jenv folder is already present.\033[1;34m"
fi