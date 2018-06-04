#!/bin/bash

##
## required packackages:
##
## sox 
## https://github.com/primatelang/mcr

set -e

EXP_NAME="$1"
DATA_DIR="$2"
OUTPUT_DIR="$3"

echo $EXP_NAME $DATA_DIR $OUTPUT_DIR

# check if variables
[ ! -z "$DATA_DIR" ] || failure "DATA_DIR command line argument not set"
[ ! -z "$OUTPUT_DIR" ] || failure "OUTPUT_DIR command line argument not set"

OUTPUT_PATH=$(realpath "$OUTPUT_DIR")
export OUTPUT_DIR="${OUTPUT_PATH}"

DATA_PATH=$(realpath "$DATA_DIR")
export DATA_DIR="${DATA_PATH}"


#
## remove previous outputs
#
rm -rf "$OUTPUT_DIR/*.csv" "$OUTPUT_DIR/wav" "$OUTPUT_DIR/${EXP_NAME}.*"

#
## preparing data
#
mkdir -p "$OUTPUT_DIR/wav"
echo "##################"
echo "# Preparing data #"
echo "##################"

# extracting annotations
echo "doing prep_annot"
prep_annot.sh "$DATA_DIR" "$OUTPUT_DIR"


cd "$DATA_DIR"
# fixing sampling rate, wav files are in same directory than
# Praat TextGrid file
echo "fixing wav files type"
shopt -s nullglob
for original_wav in "$DATA_DIR"/*.{WAV,wav,aif}; do
    ext_file="${original_wav##*.}"
    new_wav="$OUTPUT_DIR/wav/"$(basename "$original_wav" .$ext_file | tr ' ' '_');
    echo "$original_wav -> $new_wav.wav" >> "${OUTPUT_DIR}/${EXP_NAME}".log
    sox -V0 "$original_wav" -e signed-integer -b 16 -c 1 \
        -r 16000 "$new_wav".wav 2>&1 >> "$OUTPUT_DIR/${EXP_NAME}".log
done



