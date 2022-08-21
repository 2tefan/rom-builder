#!/bin/sh
# This files sets up the environment for building Android ROMs
# Normally, this should automatically be sourced
# If not then do it yourself: `source ~/.arb`

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME"/bin ] ; then
    export "PATH=$HOME/bin:$PATH"
fi

export USE_CCACHE=1
export CCACHE_EXEC="$(command -v ccache)"
