#!/bin/bash

set -e

# directories where data is keep 
export TMPDIR=~/projects/mcr_corpus_analysis/tmp/
export OUTPUT_DIR=~/projects/mcr_corpus_analysis/outputs/
export INPUT_DIR=~/projects/mcr_corpus_analysis/inputs/
export BIN=~/projects/mcr_corpus_analysis/bin
export CONFIG=~/projects/mcr_corpus_analysis/config
mkdir -p $TMPDIR


# experiment name 
export EXP_NAME='SPECTRAL_STACK50_NFILT40_6ca96b'


# equivalent to $(readlink -f $1) in pure bash (compatible with macos)
function realpath {
    readlink -f $1
    #pushd $(dirname $1) > /dev/null
    #echo $(pwd -P)
    #popd > /dev/null
}
export -f realpath;


# called on script errors
function failure { [ ! -z "$DATA_DIR" ] && echo "Error: $DATA_DIR"; exit 1; }
export -f failure;

