#!/usr/bin/env bash


PATH_TO_DATA_ROOT="/home/daniel/scratch"

TMP_FOLDER="/mnt/data/Episurfsr/tmp"

WEIGHTS_FOLDER="weights_test"
LOG_FOLDER="logs"


cmd="python SegSRGAN/SegSRGAN_training.py"
args=()
args+=(-e 1)  # num epochs
args+=(--new_low_res "0.35 2.8 0.35")  # minimum resolution
args+=(--new_low_res "0.55 3.5 0.55")  # maximum resolution
args+=(--csv "${PATH_TO_DATA_ROOT}/splits/training.csv")
args+=(--snapshot_folder "${PATH_TO_DATA_ROOT}/${WEIGHTS_FOLDER}")
args+=(--dice_file "${PATH_TO_DATA_ROOT}/${LOG_FOLDER}/dice.csv")
args+=(--mse_file "${PATH_TO_DATA_ROOT}/${LOG_FOLDER}/mse.csv")
args+=(--folder_training_data "${TMP_FOLDER}")
args+=(--number_of_disciminator_iteration 1)

${cmd} ${args[@]}
