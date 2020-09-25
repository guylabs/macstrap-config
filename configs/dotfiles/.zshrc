#!/bin/sh

bindkey '^R' history-incremental-search-backward

# Enable colors
autoload -U colors && colors

# Disable auto correction
unsetopt correct_all

# Turn off case sensitive globbing
setopt NO_CASE_GLOB

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

# Enable completion system
autoload -Uz compinit && compinit

# Enable case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Enable partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix

# Load bashcompinit for some old bash completions
autoload bashcompinit && bashcompinit

# Source macstrap files
for file in ~/.macstrap/configs/dotfiles/.{aliases,exports,path,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && . "$file";
done;
unset file;

# Start starship
eval "$(starship init zsh)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

