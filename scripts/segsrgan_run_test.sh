#!/usr/bin/env bash


PATH_TO_DATA_ROOT="/home/daniel/scratch"

OUTPUT_IMG_FOLDER="output_LC"
WEIGHTS_FOLDER="weights_test"
WEIGHTS_NAME="SegSRGAN_epoch_100"

PATCH_SIZE=64
STEP_SIZE=32


cmd="python SegSRGAN/job_model.py"
args=()
args+=(--path "${PATH_TO_DATA_ROOT}/splits/test_LC.csv")
args+=(--patch ${PATCH_SIZE})
args+=(--step ${STEP_SIZE})
args+=(--result_folder_name "${PATH_TO_DATA_ROOT}/${OUTPUT_IMG_FOLDER}/${WEIGHTS_NAME}")
args+=(--weights_path "${PATH_TO_DATA_ROOT}/${WEIGHTS_FOLDER}/${WEIGHTS_NAME}")

${cmd} ${args[@]}

