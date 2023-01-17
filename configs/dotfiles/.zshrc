#!/bin/sh

if [ -n "$PROFILE" ]; then
  echo "Profiling ZSH shell startup enabled"
  zmodload zsh/zprof
  set -x
fi

bindkey '^R' history-incremental-search-backward

# Enable colors
autoload -Uz colors && colors

# Disable auto correction
unsetopt correct_all

# Turn off case sensitive globbing
setopt NO_CASE_GLOB

# Turn off no match globbing errors
unsetopt NOMATCH

# Change directory without explicit `cd` command
setopt AUTO_CD

# Save the command history
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

# Add extended history like timestamp and execution time of the command
setopt EXTENDED_HISTORY

# Set the limit of commands being stored
SAVEHIST=5000
HISTSIZE=2000

# Share history across multiple zsh sessions
setopt SHARE_HISTORY

# Append the commands to the history
setopt APPEND_HISTORY

# Adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY

# Expire hoistory duplicates first
setopt HIST_EXPIRE_DUPS_FIRST

# Do not store duplicates
setopt HIST_IGNORE_DUPS

# Ignore duplicates when searching
setopt HIST_FIND_NO_DUPS

# Remove blank lines from history
setopt HIST_REDUCE_BLANKS

# Enable case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Enable partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Export brew environment variables
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load Homebrew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  chmod -R go-w "$(brew --prefix)/share"
fi

# Enable completion system and only evaluate it once a day
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Source macstrap files
for file in ~/.macstrap/configs/dotfiles/.{aliases,exports,extra,path}; do
	[ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
    # Start Starship for non-WarpTerminal terminals (e.g. IntelliJ, VSCode, ect...)
    eval "$(starship init zsh)"
fi

# Add ASDF to ZSH
. $(brew --prefix asdf)/libexec/asdf.sh

# Set JAVA_HOME
. ~/.asdf/plugins/java/set-java-home.zsh

if [ -n "$PROFILE" ]; then
  echo "ZSH Profile results:\n\n"
  zprof
fi
