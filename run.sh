#!/bin/bash

export exp_name='SPECTRAL_STACK50_NFILT40_6ca96b'

function r_abx {
    input_dir=$1
    output_dir=$2
    mkdir -p $output_dir
    cp ./config/${exp_name}.cfg "$output_dir"

    # run_abx.sh from mcr package
    run_abx.sh "$exp_name" "$input_dir" "$output_dir" 
}

#
## Putty Nosed
#
input_dir=./corpus/Putty_nosed 
output_dir=./outputs/Putty_nosed/
r_abx $input_dir $output_dir

#
## Campbell's monkey
#
input_dir=./corpus/Campbell_Tiwai_recordings
output_dir=./outputs/Campbell_Tiwai_recordings
r_abx $input_dir $output_dir


#
## Blue monkey
#
input_dir=./corpus/Blue_monkey/Murphy 
output_dir=././outputs/Blue_monkey/Murphy/
r_abx $input_dir $output_dir

input_dir=./corpus/Blue_monkey/James_Fuller/Audio 
output_dir=././outputs/Blue_monkey/James_Fuller/
r_abx $input_dir $output_dir


#
## Colobus guereza
#
input_dir=./corpus/Colobus_guereza
output_dir=./outputs/Colobus_guereza/
r_abx $input_dir $output_dir


#
## Titi
#
input_dir=./corpus/Titi_monkey/Non-predator_sequences 
output_dir=./outputs/Titi_monkey/Non-predator_sequences/
r_abx $input_dir $output_dir

input_dir=./corpus/Titi_monkey/Raptor_model_canopy
output_dir=./outputs/Titi_monkey/Raptor_model_canopy/
r_abx $input_dir $output_dir


#
## Gibbons
#
# NOTE: Gibbons' calls are repeted all time, there number of calls is high
# and that does make abx collapse (too many triplets)
#input_dir=./corpus/Gibbons
#output_dir=./outputs/Gibbons/
#mkdir -p $output_dir
#cp /home/juan/projects/mcr/src/segmented.cfg "$output_dir"
#run_abx.sh "$input_dir" "$output_dir"
