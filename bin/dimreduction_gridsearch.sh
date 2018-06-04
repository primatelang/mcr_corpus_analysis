#!/bin/bash

##
## required packackages:
##
## https://github.com/primatelang/mcr
## https://github.com/primatelang/easy_abxpy 
## gnu-parallel: https://www.gnu.org/software/parallel/ 
##               to install parallel you can run in linux
##
##   (wget -O - pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3) | bash
##

set -e

# moving to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR

# load config variables 
. ${DIR}/config.sh

mkdir -p $OUTPUT_DIR

# grid search on dimensions
function prepare_run {
    export ND=$1;
    input_dir=$2 
    output_dir=$3

    # I keep each running data preparation and dimension reduction in a 
    # separate temporal directory to avoid conflicts or race conditions when 
    # running the script with gnu-parallel 
    output_tmp=$(mktemp -d --tmpdir=$TMPDIR) 
    echo "... tmp: $output_tmp"

    export EXP_NAME=$(echo $ND | awk '{printf("SPECTRAL_STACK50_NFILT40_6ca96b_ND%02d", $1)}');

    cp -rf $INPUT_DIR/annotations.csv ${output_tmp}/
    sed 's/xXx/'$ND'/g' ${INPUT_DIR}/base.cfg > \
        ${output_tmp}/${EXP_NAME}.cfg

    ${BIN}/prepare_data.sh "$EXP_NAME" "$input_dir" "$output_tmp" 
    ${BIN}/run_dimreduction.sh "$EXP_NAME" "$output_tmp" 

    echo "copying: ${output_tmp}, experiment:${EXP_NAME}, new dimensions=$ND"
    mkdir -p "$output_dir"
    cp -r ${output_tmp}/* $output_dir
    rm -rf $output_tmp
};
export -f prepare_run;

# generating results for a single dimension reduction size
input_dir=${INPUT_DIR}/corpus/Blue_monkey/Murphy/
output_dir=${OUTPUT_DIR}/Blue_monkey/Murphy/
prepare_run 20 "$input_dir" "$output_dir"

# generating results for mutiple dimension reduction sizes
#echo -e "20\n30\n10\n5" | parallel --eta --files -j 1 prepare_run {} "$input_dir" "$output_dir" 

