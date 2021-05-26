#!/usr/bin/env bash

list_of_subjects_train="/home/daniel/opt_temp/splits/normalised_6/contrast_1_HS/subjects_train.txt"
list_of_subjects_valid="/home/daniel/opt_temp/splits/normalised_6/contrast_1_HS/subjects_valid.txt"
list_of_subjects_test="/home/daniel/opt_temp/splits/normalised_6/contrast_1_HS/subjects_test.txt"

PATH_TO_OUTPUT_FOLDER="/home/daniel/scratch/splits"

# nifti dataset
#PATH_TO_DATAROOT="/home/daniel/opt_temp/normalised_6"
#SUFFIX_HR="highres"
#SUFFIX_LABEL="c"
#FOLDER_LABEL="segmentation/masks"

# iso 3d sv dataset
PATH_TO_DATAROOT="/home/daniel/mnt_data_daniel/3d_sv_nifti_dataset_iso_LR_6"
SUFFIX_HR="highres_target"
SUFFIX_LABEL="mask"
FOLDER_LABEL=""

# CSV settings
HEADER="HR_image,Label_image,Base"


function write_csv(){
# Write csv with training / validation data.
# args: 1 - path to dataroot; 2 - path to subject list; 3 - mode (train / test); 4 - path to output file

    local path_to_dataroot=${1}
    local path_to_subject_list=${2}
    local mode=${3}
    local path_to_output_file=${4}

    if [[ ${mode} == "Train" ]]
    then
        echo ${HEADER} >> ${path_to_output_file}
    fi

    for subject in $(cat ${path_to_subject_list})
    do

        echo "Working on ${subject}."

        path_to_subject_folder="${path_to_dataroot}/${subject}"

        hr_image="${path_to_subject_folder}/${subject}_${SUFFIX_HR}.nii.gz"
        label_image="${path_to_subject_folder}/${FOLDER_LABEL}/${subject}_${SUFFIX_LABEL}.nii.gz"

        echo "${hr_image},${label_image},${mode}" >> ${path_to_output_file}

    done

}


write_csv "${PATH_TO_DATAROOT}/training" ${list_of_subjects_train} "Train" "${PATH_TO_OUTPUT_FOLDER}/training_iso_HS.csv"
write_csv "${PATH_TO_DATAROOT}/validation" ${list_of_subjects_valid} "Test" "${PATH_TO_OUTPUT_FOLDER}/training_iso_HS.csv"  # NOTE: this is validation, but in SegSRGAN it is called 'test', too.
write_csv "${PATH_TO_DATAROOT}/test" ${list_of_subjects_test} "Test" "${PATH_TO_OUTPUT_FOLDER}/test_iso_HS.csv"
