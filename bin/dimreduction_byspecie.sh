#!/bin/bash

set -e 

# moving to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR

# load config variables 
. ${DIR}/config.sh


function run_pipeline {
    input_dir=$1
    output_dir=$2
    mkdir -p $output_dir
    cp ${CONFIG}/${EXP_NAME}.cfg "$output_dir"
    
    ${BIN}/prepare_data.sh "$EXP_NAME" "$input_dir" "$output_dir" 
    ${BIN}/run_dimreduction.sh "$EXP_NAME" "$output_dir" 
}

echo "...Blue monkey..."
input_dir=${INPUT_DIR}/corpus/Blue_monkey/Murphy/
output_dir=${OUTPUT_DIR}/Blue_monkey/Murphy/
run_pipeline $input_dir $output_dir

## example of other calls that are available

#input_dir=${INPUT_DIR}/corpus/Blue_monkey/James_Fuller/Audio/
#output_dir=${OUTPUT_DIR}/Blue_monkey/James_Fuller/
#run_pipeline $input_dir $output_dir
#
#input_dir=${INPUT_DIR}/corpus/Blue_monkey/Join/
#output_dir=${OUTPUT_DIR}/Blue_monkey/Join
#run_pipeline $input_dir $output_dir
#
#echo "...Campbel monkey..."
#input_dir=${INPUT_DIR}/corpus/Campbell_Tiwai_recordings/
#output_dir=${OUTPUT_DIR}/Campbell_Tiwai_recordings
#run_pipeline $input_dir $output_dir
#
#echo "...Columbus..."
#input_dir=${INPUT_DIR}/corpus/Colobus_guereza/
#output_dir=${OUTPUT_DIR}/Colobus_guereza
#run_pipeline $input_dir $output_dir
#
#echo "...Putty..."
#input_dir=${INPUT_DIR}/corpus/Putty_nosed/
#output_dir=${OUTPUT_DIR}/Putty_nosed
#run_pipeline $input_dir $output_dir
#
#
#echo "...Titi not predator..."
#input_dir=${INPUT_DIR}/corpus/Titi_monkey/Non-predator_sequences/
#output_dir=${OUTPUT_DIR}/Non-predator_sequences
#run_pipeline $input_dir $output_dir
#
#echo "...Titi raptor canopy..."
#input_dir=${INPUT_DIR}/corpus/Titi_monkey/Raptor_model_canopy/
#output_dir=${OUTPUT_DIR}/Raptor_model_canopy
#run_pipeline $input_dir $output_dir

