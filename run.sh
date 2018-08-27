#!/bin/bash 

rm -rf .cache

# get the features for all calls and for free length window 
extract_features -o SPECTRAL_STACKFREE_NFILT40_c74e01_features.csv \
    inputs/annotations.all config/SPECTRAL_STACKFREE_NFILT40_c74e01.cfg

rm -rf .cache
# get the features for all calls and for 50 frames length window 
extract_features -o SPECTRAL_STACK50_NFILT40_c11783_features.csv \
    inputs/annotations.all config/SPECTRAL_STACK50_NFILT40_c11783.cfg


