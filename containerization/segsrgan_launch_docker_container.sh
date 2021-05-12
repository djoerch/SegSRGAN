#!/usr/bin/env bash


if [[ $# == 1 ]]
then
  mode=${1}
else
  mode="-d"
fi


HOST_PORT_JUPYTER=8878
HOST_PORT_SSH=8822
HOST_PATH="/home/daniel"
CONTAINER_PATH="/home/daniel"
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
args+=(--workdir "${CONTAINER_PATH}")
args+=(-p ${HOST_PORT_JUPYTER}:8888)
args+=(-p ${HOST_PORT_SSH}:22)
args+=(-v ${HOST_PATH}:${CONTAINER_PATH})
args+=(--name=${CUSTOM_CONTAINER_NAME})
args+=(-t ${IMAGE_TAG})

${cmd} ${args[@]}
