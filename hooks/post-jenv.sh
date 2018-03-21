#!/usr/bin/env bash
set -e

  export JENV_ROOT=/usr/local/opt/jenv
# Install jEnv
if which jenv > /dev/null; then
  eval "$(jenv init -)"

  # Add Java 6
  jenv add $(/usr/libexec/java_home -v 1.6)

  # Add Java 8
  jenv add $(/usr/libexec/java_home -v 1.8)

  # Add Java 9
  jenv add $(/usr/libexec/java_home -v 9)

  # Set the Java 8 as global Java
  jenv global 1.8

  # Enable export plugin
  jenv enable-plugin export

else
  echo -e "\033[0;33mWARN: jEnv not installed as the ~/.jenv folder is already present.\033[1;34m"
fi