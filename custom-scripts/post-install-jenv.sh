#!/usr/bin/env bash
set -e

# Install jEnv
if [ ! -d "$HOME/.jenv" ]; then
  git clone https://github.com/gcuisinier/jenv.git ~/.jenv
  export PATH=$HOME/.jenv/bin:$PATH
  eval "$(jenv init -)"
  jenv add `/usr/libexec/java_home`
  jenv global 1.7
else
  echo -e "\033[0;33mWARN: jEnv not installed as the ~/.jenv folder is already present.\033[1;34m"
fi