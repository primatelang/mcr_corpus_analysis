#!/bin/bash

##
## required packackages:
##
## https://github.com/primatelang/mcr
## https://github.com/primatelang/easy_abxpy 
##

set -e

# moving to the script directory                       
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR                                              

# load config variables   
. ${DIR}/config.sh        


EXP_NAME="$1"
OUTPUT_DIR="$2"

# source activate abx

# check if variables
[ ! -z "$OUTPUT_DIR" ] || failure "OUTPUT_DIR command line argument not set"


# expanding the pathnames
OUTPUT_PATH=$(realpath "$OUTPUT_DIR")
export OUTPUT_DIR="${OUTPUT_PATH}"


#
## extract features from wav files poited by annotations.csv 
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

