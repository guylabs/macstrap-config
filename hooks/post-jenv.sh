#!/usr/bin/env bash
set -e

# Install jEnv
if [ ! -d "$HOME/.jenv" ]; then
  export JENV_ROOT=/usr/local/opt/jenv
  eval "$(jenv init -)"

  # Set the Java 8 as global Java
  jenv add $(/usr/libexec/java_home -v 1.8)
  jenv global oracle-1.8
else
  echo -e "\033[0;33mWARN: jEnv not installed as the ~/.jenv folder is already present.\033[1;34m"
fi