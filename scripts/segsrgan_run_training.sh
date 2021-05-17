#!/usr/bin/env bash


PATH_TO_DATA_ROOT="/home/daniel/scratch"

EXP_FOLDER="discriminator_2"

TMP_FOLDER="/mnt/data/Episurfsr/tmp"

WEIGHTS_FOLDER="weights_test"
LOG_FOLDER="logs"


CONTINUE_FROM_EPOCH=10


mkdir ${EXP_FOLDER}


cmd="python SegSRGAN/SegSRGAN_training.py"
args=()
args+=(-e 100)  # num epochs
args+=(--new_low_res "0.35 2.8 0.35")  # minimum resolution
args+=(--new_low_res "0.55 3.5 0.55")  # maximum resolution
args+=(--csv "${PATH_TO_DATA_ROOT}/splits/training.csv")
args+=(--snapshot_folder "${PATH_TO_DATA_ROOT}/${EXP_FOLDER}/${WEIGHTS_FOLDER}")
args+=(--dice_file "${PATH_TO_DATA_ROOT}/${EXP_FOLDER}/${LOG_FOLDER}/dice.csv")
args+=(--mse_file "${PATH_TO_DATA_ROOT}/${EXP_FOLDER}/${LOG_FOLDER}/mse.csv")
args+=(--folder_training_data "${TMP_FOLDER}")
args+=(--number_of_disciminator_iteration 2)

# comment out next 2 lines to deactivate continued training
#args+=(--init_epoch $((CONTINUE_FROM_EPOCH+1)))  # last_epoch + 1
#args+=(--weights "${PATH_TO_DATA_ROOT}/${EXP_FOLDER}/${WEIGHTS_FOLDER}/SegSRGAN_epoch_${CONTINUE_FROM_EPOCH}")

${cmd} ${args[@]}
