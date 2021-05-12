#!/usr/bin/env bash

list_of_subjects_train="/home/daniel/opt_temp/splits/normalised_6/contrast_1_HS/subjects_train.txt"
list_of_subjects_valid="/home/daniel/opt_temp/splits/normalised_6/contrast_1_HS/subjects_valid.txt"
list_of_subjects_test="/home/daniel/opt_temp/splits/normalised_6/contrast_1_HS/subjects_test.txt"

PATH_TO_OUTPUT_FOLDER="/home/daniel/scratch/splits"

PATH_TO_DATAROOT="/home/daniel/opt_temp/normalised_6"

HEADER="HR_image,Label_image,Base"


function write_csv(){
# Write csv with training / validation data.
# args: 1 - path to subject list; 2 - mode (train / test); 3 - path to output file

    local path_to_subject_list=${1}
    local mode=${2}
    local path_to_output_file=${3}

    if [[ ${mode} == "Train" ]]
    then
        echo ${HEADER} >> ${path_to_output_file}
    fi

    for subject in $(cat ${path_to_subject_list})
    do

        echo "Working on ${subject}."

        path_to_subject_folder="${PATH_TO_DATAROOT}/${subject}"

        hr_image="${path_to_subject_folder}/${subject}_highres.nii.gz"
        label_image="${path_to_subject_folder}/segmentation/masks/${subject}_c.nii.gz"

        echo "${hr_image},${label_image},${mode}" >> ${path_to_output_file}

    done

}


write_csv ${list_of_subjects_train} "Train" "${PATH_TO_OUTPUT_FOLDER}/training.csv"
write_csv ${list_of_subjects_valid} "Test" "${PATH_TO_OUTPUT_FOLDER}/training.csv"  # NOTE: this is validation, but in SegSRGAN it is called 'test', too.
write_csv ${list_of_subjects_test} "Test" "${PATH_TO_OUTPUT_FOLDER}/test.csv"
