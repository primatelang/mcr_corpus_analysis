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

# ALGO_CONFIG_FREE is the configuration file for extracting free window length features, 
# the methods that can reduce the dimension of these variable size features and  
# using in here are LSTM autoencoder/embeddings and tripelet-loss embeddings.
#
# ALGO_CONFIG_ST50 has the configuration for extracting 50 frames window features (0.5s) 
# from the acoustic files, the dimension reduction used here are PCA and LDA.
# 

# the new reduced size is 20 on $ALGO_CONFIG_*
feature_size=21

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
ANNOTATIONS=inputs/annotations.all

rm -rf .cache                                                          
# get the features for all calls and for 50 frames length window       
extract_features -o ST50_features "$ANNOTATIONS" "$ALGO_CONFIG_ST50" 
extract_features -o FREE_features "$ANNOTATIONS" "$ALGO_CONFIG_FREE"


function size_features {
    f=$1
    feature_size=$(head -n 1 $f | awk -F',' '{print NF}')
    echo $feature_size
}
export -f size_features;

# pca 
reduce_features ST50_features "$ALGO_CONFIG_ST50" -r pca --standard_scaler \
    -o pca_dimension_reduction_features_20D.csv

# lda 
reduce_features ST50_features "$ALGO_CONFIG_ST50" -r lda --standard_scaler \
    -o lda_dimension_reduction_features_20D.csv  

# lstm autoencoder
reduce_features FREE_features "$ALGO_CONFIG_FREE" -r lstm --standard_scaler \
    -o lstm_autoencoder_features_20D.csv

# triplet loss lstm embeddings 
reduce_features FREE_features "$ALGO_CONFIG_FREE" -r tripletloss \
    -o tripletloss_embeddings_features_20D.csv

compute_abx tripletloss_embeddings_features_20D.csv \
    --col_on 1 --col_features 2-$feature_size > tripletloss_embeddings_features_20D_abx.csv

# lstm embeddings 
reduce_features FREE_features "$ALGO_CONFIG_FREE" -r lstmembed --standard_scaler \
    -o lstm_embeddings_features_20D.csv


parallel "compute_abx {} --col_on 1 --col_features 2-$feature_size > {.}_abx.csv" ::: \
    pca_dimension_reduction_features_20D.csv \
    lda_dimension_reduction_features_20D.csv \
    lstm_autoencoder_features_20D.csv \
    tripletloss_embeddings_features_20D.csv \
    lstm_embeddings_features_20D.csv


    
