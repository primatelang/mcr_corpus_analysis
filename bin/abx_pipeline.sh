#!/bin/bash

##
## required packackages:
##
## https://github.com/primatelang/mcr
## https://github.com/primatelang/easy_abxpy 
##

set -e

EXP_NAME="$1"
DATA_DIR="$2"
OUTPUT_DIR="$3"

# source activate abx

# equivalent to $(readlink -f $1) in pure bash (compatible with macos)
function realpath {
    readlink -f "$1"
}
export -f realpath;


# called on script errors
function failure { [ ! -z "$DATA_DIR" ] && echo "Error: $DATA_DIR"; exit 1; }


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


#
## running feat extraction and ABX
#
function extract_features_ {
    RTYPE=$1
    echo "extract_features $RTYPE" 
    extract_features "${OUTPUT_DIR}/annotations.csv" \
                     "${OUTPUT_DIR}/${EXP_NAME}.cfg" \
                  -o "${OUTPUT_DIR}/${EXP_NAME}_original_features.csv" \

}

function reduce_features_ {
    RTYPE=$1
    echo "reduce_features $RTYPE"
    reduce_features "${OUTPUT_DIR}/${EXP_NAME}_original_features.csv" \
                    "${OUTPUT_DIR}/${EXP_NAME}.cfg" \
                 -r "${RTYPE}" --standard_scaler \
                 -o "${OUTPUT_DIR}/${EXP_NAME}_${RTYPE}_features.csv"

}

function run_abx_ {
    RTYPE=$1
    echo "computing_abx $RTYPE"
    bfile="${OUTPUT_DIR}/${EXP_NAME}_${RTYPE}"
    last_feature=$(head -n 1 "${bfile}_features.csv" | awk -F',' '{print NF}')
    compute_abx "${bfile}_features.csv" --col_on 1 --col_features 2-$last_feature > "${bfile}_abx.csv"
}


echo "#########################################"
echo "# Extracting features from acustic data #"
echo "#########################################"
extract_features_ lda
extract_features_ lsa
extract_features_ pca
extract_features_ raw
extract_features_ tsne
extract_features_ ae
extract_features_ lstm
extract_features_ tripletloss 


echo "#####################################"
echo "# Dimensional reduction of features #"
echo "#####################################"
reduce_features_ lda
reduce_features_ lsa
reduce_features_ pca
reduce_features_ raw
reduce_features_ tsne
reduce_features_ ae
reduce_features_ lstm
reduce_features_ tripletloss 

echo "#################"
echo "# Running ABX ..#"
echo "#################"
run_abx_ lda
run_abx_ lsa
run_abx_ pca
run_abx_ raw
run_abx_ tsne
run_abx_ ae
run_abx_ lstm
run_abx_ tripletloss

# source deactivate

