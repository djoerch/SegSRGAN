#!/usr/bin/env bash

# example call: `bash segsrgan_launch_docker_container.sh -it`


if [[ $# == 1 ]]
then
  mode=${1}
else
  mode="-d"
fi


HOST_PORT_JUPYTER=8878
HOST_PORT_SSH=8822
HOME_DIR="/home/daniel"
HOST_PATHS=("${HOME_DIR}" "/mnt/data")
CONTAINER_PATHS=("${HOME_DIR}" "/mnt/data")
CUSTOM_CONTAINER_NAME="segsrgan_container"
IMAGE_TAG="segsrgan"


cmd="docker"
args=()
args+=("run")
args+=(${mode})
args+=(--rm)
args+=(-u "$(id -u):$(id -g)")
args+=(--gpus "device=0")
args+=(--cpus="12")
args+=(--memory="32g")
args+=(--shm-size="512m")
args+=(--workdir "${HOME_DIR}")
args+=(-p ${HOST_PORT_JUPYTER}:8888)
args+=(-p ${HOST_PORT_SSH}:22)
for index in ${!HOST_PATHS[@]}
do
    args+=(-v ${HOST_PATHS[${index}]}:${CONTAINER_PATHS[${index}]})
done
args+=(--name=${CUSTOM_CONTAINER_NAME})
args+=(-t ${IMAGE_TAG})

${cmd} ${args[@]}
