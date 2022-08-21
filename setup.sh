#!/bin/env bash

set -eu

mkdir mkdir -p ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo >~/bin/repo
chmod a+x ~/bin/repo

echo "# Source file for environment variables for the ROM build
if [ -f ~/.arb ]; then
    . ~/.arb
fi
" >>"${HOME_DIR}/.bashrc"

echo "# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi" >> /etc/bash.bashrc


ccache -M 100G
