#!/usr/bin/env bash


PATH_TO_DATA_ROOT="/home/daniel/scratch"

EXP_FOLDER="discriminator_5"

OUTPUT_IMG_FOLDER="output_HS_LR_sim"
WEIGHTS_FOLDER="weights_test"
WEIGHTS_NAME="SegSRGAN_epoch_200"

PATCH_SIZE=128
STEP_SIZE=32

SEG_ALGO="25D"


path_to_result_folder="${PATH_TO_DATA_ROOT}/${EXP_FOLDER}/${OUTPUT_IMG_FOLDER}/${WEIGHTS_NAME}"
path_to_eval_folder="${path_to_result_folder}/patch_${PATCH_SIZE}_step_${STEP_SIZE}"
path_to_seg_folder="${path_to_eval_folder}_segmentation"


# run SR
cmd="python SegSRGAN/job_model.py"
args=()
args+=(--path "${PATH_TO_DATA_ROOT}/splits/test_HS_LR_sim.csv")
args+=(--patch ${PATCH_SIZE})
args+=(--step ${STEP_SIZE})
args+=(--result_folder_name "${path_to_result_folder}")
args+=(--weights_path "${PATH_TO_DATA_ROOT}/${EXP_FOLDER}/${WEIGHTS_FOLDER}/${WEIGHTS_NAME}")
args+=(--new_low_res "0.5 0.5 0.5")

#${cmd} ${args[@]}

# prepare seg environment
source ~/segmentation/configs/segmentation_config.bashrc

# run segmentation using `episurfsr`
cmd="episr_compute_seg_metrics_for_dataset.sh"
args=()
args+=("${path_to_eval_folder}")
args+=("${path_to_seg_folder}")
args+=("_SR")
args+=("${SEG_ALGO}")
args+=("/home/daniel/opt_temp/normalised_6")

#${cmd} ${args[@]}


# prepare summary folder
mkdir -p "${path_to_seg_folder}/.summary"

# make visualisation of seg metrics
cmd="episr_visualise_seg_metrics.py"
args=()
args+=(-i "${path_to_seg_folder}")
args+=(--title "SegSRGAN (eval: HS; ${SEG_ALGO}; patch: ${PATH_SIZE})")
args+=(--ylim "20")
args+=(-o "${path_to_seg_folder}/.summary/summary.png")

#${cmd} "${args[@]}"


# make png summaries (SR)
for path_to_subj in ${path_to_eval_folder}/*
do
    for path_to_file in ${path_to_subj}/*.nii.gz
    do
        mrpeek -batch ${path_to_file} | sixel2png > ${path_to_file/%.nii.gz/.png}
    done
done

# make png summaries (seg)
for path_to_subj in ${path_to_seg_folder}/*
do
    for path_to_file in ${path_to_subj}/segmentation/Femural_Cartilage/*.nii.gz
    do
        mrpeek -batch ${path_to_file} | sixel2png > ${path_to_file/%.nii.gz/.png}
    done
done
