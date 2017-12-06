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

###echo "...Putty Nosed..."
###input_dir=./corpus/Putty_nosed 
###output_dir=./outputs/Putty_nosed/
###run_pipeline $input_dir $output_dir
###
###
###echo "...Campbell's monkey..."
###input_dir=./corpus/Campbell_Tiwai_recordings
###output_dir=./outputs/Campbell_Tiwai_recordings
###run_pipeline $input_dir $output_dir
###
###
echo "...Blue monkey..."
input_dir=./corpus/Blue_monkey/Murphy 
output_dir=././outputs/Blue_monkey/Murphy/
run_pipeline $input_dir $output_dir

input_dir=./corpus/Blue_monkey/James_Fuller/Audio 
output_dir=././outputs/Blue_monkey/James_Fuller/
run_pipeline $input_dir $output_dir
###
###
###echo "...Colobus guereza..."
###input_dir=./corpus/Colobus_guereza
###output_dir=./outputs/Colobus_guereza/
###run_pipeline $input_dir $output_dir
###
###
###echo "...Titi..."
###input_dir=./corpus/Titi_monkey/Non-predator_sequences 
###output_dir=./outputs/Titi_monkey/Non-predator_sequences/
###run_pipeline $input_dir $output_dir
###
###input_dir=./corpus/Titi_monkey/Raptor_model_canopy
###output_dir=./outputs/Titi_monkey/Raptor_model_canopy/
###run_pipeline $input_dir $output_dir
###
###
###
#### Gibbons
###
### NOTE: Gibbons' calls are repeted all time, there number of calls is high
### and that does make abx collapse (too many triplets)
###input_dir=./corpus/Gibbons
###output_dir=./outputs/Gibbons/
###mkdir -p $output_dir
###cp /home/juan/projects/mcr/src/segmented.cfg "$output_dir"
###run_pipeline.sh "$input_dir" "$output_dir"
