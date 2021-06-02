#!/usr/bin/env bash


# input
PATH_TO_DATA_ROOT="/home/daniel/scratch"

# tmp (will be created and deleted automatically)
TMP_FOLDER="/mnt/data/Episurfsr/tmp"

# output
EXP_FOLDER="discriminator_5_iso_HS_mask_overlap"
#EXP_FOLDER="discriminator_5_mask_overlap"
WEIGHTS_FOLDER="weights_test"
LOG_FOLDER="logs"


#CONTINUE_FROM_EPOCH=6


path_to_exp_folder=${PATH_TO_DATA_ROOT}/${EXP_FOLDER}
path_to_weights_folder=${path_to_exp_folder}/${WEIGHTS_FOLDER}
path_to_log_folder=${path_to_exp_folder}/${LOG_FOLDER}

# assert the output folders exist
mkdir -p ${path_to_exp_folder}
mkdir -p ${path_to_weights_folder}
mkdir -p ${path_to_log_folder}


cmd="python SegSRGAN/SegSRGAN_training.py"
args=()
args+=(-e 200)  # num epochs
args+=(--new_low_res "0.35 2.8 0.35")  # minimum resolution
args+=(--new_low_res "0.55 3.5 0.55")  # maximum resolution
args+=(--csv "${PATH_TO_DATA_ROOT}/splits/training_iso_HS_w_mask.csv")
#args+=(--csv "${PATH_TO_DATA_ROOT}/splits/training_w_mask.csv")
args+=(--snapshot_folder "${path_to_weights_folder}")
args+=(--dice_file "${path_to_log_folder}/dice.csv")
args+=(--mse_file "${path_to_log_folder}/mse.csv")
args+=(--folder_training_data "${TMP_FOLDER}")
args+=(--number_of_disciminator_iteration 5)
args+=(--image_cropping_method "overlapping_with_mask")

# comment out next 2 lines to deactivate continued training
#args+=(--init_epoch $((CONTINUE_FROM_EPOCH+1)))  # last_epoch + 1
#args+=(--weights "${path_to_weights_folder}/SegSRGAN_epoch_${CONTINUE_FROM_EPOCH}")

${cmd} ${args[@]}
