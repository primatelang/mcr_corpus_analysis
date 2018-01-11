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

source activate abx

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
function create_abx_files {
    RTYPE=$1

    echo '         |--- extract_features'
    extract_features "${OUTPUT_DIR}/annotations.csv" \
                     "${OUTPUT_DIR}/${EXP_NAME}.cfg" \
                  -o "${OUTPUT_DIR}/${EXP_NAME}_features.csv" \

    echo '         |--- reduce_features'
    reduce_features "${OUTPUT_DIR}/${EXP_NAME}_features.csv" \
                    "${OUTPUT_DIR}/${EXP_NAME}.cfg" \
                 -r "${RTYPE}" --standard_scaler \
                 --standard_scaler \
                 -o "${OUTPUT_DIR}/${EXP_NAME}_${RTYPE}_input.csv"

    echo '         |--- prepare_abx'
    last_feature=$(head -n 1 "${OUTPUT_DIR}/${EXP_NAME}_${RTYPE}_input.csv" | awk -F',' '{print NF}')

    prepare_abx "${OUTPUT_DIR}/${EXP_NAME}_${RTYPE}_input.csv" \
                "${OUTPUT_DIR}/${EXP_NAME}_${RTYPE}_results" \
                --col_labels 1 --col_features 2-$last_feature
}


echo "######################################"
echo "# Preparing item and feature files ..#"
echo "######################################"
echo
echo "     ---> doing lda <---              "
echo
create_abx_files lda

echo
echo "     ---> doing lsa <---              "
echo
create_abx_files lsa

echo
echo "     ---> doing pca <---              "
echo
create_abx_files pca

echo
echo "     ---> doing raw <---              "
echo
create_abx_files raw

echo
echo "     ---> doing autoencoder <---              "
echo
create_abx_files ae

echo
echo "     ---> doing tsne <---              "
echo
create_abx_files tsne


echo "#################"
echo "# Running ABX ..#"
echo "#################"
#echo
echo "     ---> doing abx lda <---              "
echo
run_abx --on "call" "${OUTPUT_DIR}/${EXP_NAME}_lda_results"

echo
echo "     ---> doing abx lsa <---              "
echo
run_abx --on "call" "${OUTPUT_DIR}/${EXP_NAME}_lsa_results"

echo
echo "     ---> doing abx pca <---              "
echo
run_abx --on "call" "${OUTPUT_DIR}/${EXP_NAME}_pca_results"

echo
echo "     ---> doing abx raw <---              "
echo
run_abx --on "call" "${OUTPUT_DIR}/${EXP_NAME}_raw_results"

echo
echo "     ---> doing abx autoencoder <---              "
echo
run_abx --on "call" "${OUTPUT_DIR}/${EXP_NAME}_ae_results"

echo
echo "     ---> doing abx tsne <---              "
echo
run_abx --on "call" "${OUTPUT_DIR}/${EXP_NAME}_tsne_results"

source deactivate

