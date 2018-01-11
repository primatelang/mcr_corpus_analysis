#!/bin/bash

set -e 

export exp_name='SPECTRAL_STACK50_NFILT40_6ca96b'

function run_pipeline {
    input_dir=$1
    output_dir=$2
    mkdir -p $output_dir
    cp ./config/${exp_name}.cfg "$output_dir"

    ./abx_pipeline.sh "$exp_name" "$input_dir" "$output_dir" 
}

###echo "...Blue monkey..."
###input_dir=./corpus/Blue_monkey/Murphy 
###output_dir=././outputs/Blue_monkey/Murphy/
###run_pipeline $input_dir $output_dir
###
###input_dir=./corpus/Blue_monkey/James_Fuller/Audio 
###output_dir=././outputs/Blue_monkey/James_Fuller/
###run_pipeline $input_dir $output_dir

input_dir=./corpus/Blue_monkey/Join
output_dir=././outputs/Blue_monkey/Join
run_pipeline $input_dir $output_dir

