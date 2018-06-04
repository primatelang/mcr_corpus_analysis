#!/bin/bash

##
## required packackages:
##
## https://github.com/primatelang/mcr
## https://github.com/primatelang/easy_abxpy 
##

set -e

# configuration for the feature extraction and dimension reduction algorithms 
ALGO_CONFIG_FREE=config/SPECTRAL_STACKFREE_NFILT40_c74e01.cfg
ALGO_CONFIG_ST50=config/SPECTRAL_STACK50_NFILT40_6ca96b.cfg

# Experiment name ... for the names of output files 
EXP_NAME_FREE="SPECTRAL_STACKFREE_NFILT40_c74e01"
EXP_NAME_ST50="SPECTRAL_STACK50_NFILT40_6ca96b"

# csv file with the calls, it should contain in the first line  a header with the string:
#
#   filename,start,end,label
#
# all following lines are the calls that will be processed, each column contains:
#
# filename: the path and the name of the wav file that will be used to extract the acustic data
# start: timestamp in seconds for the begining of the call
# end: timetamp in seconds for the ending of the call
# label: a string with the call
#
ANNOTATIONS=inputs/annotations.bluemonkeys


#################################################
### PIPELINE FOR VARIABLE SIZE ACUSTIC WINDOW ###
#################################################
rm -rf .cache
# get the features for all calls and for free length window            
extract_features -o "${EXP_NAME_FREE}_original_features.csv" "$ANNOTATIONS" "$ALGO_CONFIG_FREE"

# REDMETHOD options are: ae, lstm, tripletloss
REDMETHOD="lstm"
reduce_features "${EXP_NAME_FREE}_original_features.csv" \
    "$ALGO_CONFIG_FREE" -r $REDMETHOD --standard_scaler \
    -o "${EXP_NAME_FREE}_${REDMETHOD}_features.csv"

feature_size=`head -n 1 "${EXP_NAME_FREE}_${REDMETHOD}_features.csv" | awk -F',' '{print NF}'`
compute_abx "${EXP_NAME_FREE}_${REDMETHOD}_features.csv" \
    --col_on 1 \
    --col_features 2-$feature_size > "${EXP_NAME_FREE}_${REDMETHOD}_abx.csv"



############################
#### FOR FIX SIZE WINDOW ###
############################
rm -rf .cache                                                          
# get the features for all calls and for 50 frames length window       
extract_features -o "${EXP_NAME_ST50}_original_features.csv" "$ANNOTATIONS"  "$ALGO_CONFIG_ST50" 

# REDMETHOD options are: lda, lsa, pca, raw, tsne, ae, lstm, tripletloss
REDMETHOD="pca"
reduce_features "${EXP_NAME_ST50}_original_features.csv" \
    "$ALGO_CONFIG_ST50" -r $REDMETHOD --standard_scaler \
    -o "${EXP_NAME_ST50}_${REDMETHOD}_features.csv" 

feature_size=`head -n 1 "${EXP_NAME_ST50}_${REDMETHOD}_features.csv" | awk -F',' '{print NF}'`
compute_abx "${EXP_NAME_ST50}_${REDMETHOD}_features.csv" \
    --col_on 1 \
    --col_features 2-$feature_size > "${EXP_NAME_ST50}_${REDMETHOD}_abx.csv"


