#!/usr/bin/env bash

# params:
#  1,... - command to launch in docker container
# kwargs:
#  --docker-mount-path <PATH> - path to mount in docker container
#  --docker-container-name <NAME> - name of the container image to launch
#  --docker-container-tag <TAG> - tag of the container image to launch

GPUS="all"

DOCKER_CONTAINER_NAME="segsrgan"
DOCKER_CONTAINER_TAG="latest"


POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case ${key} in
        --docker-mount-path)
            DOCKER_MOUNT_PATH="$2"
            shift # past argument
            shift # past value
            ;;
        --docker-container-name)
            DOCKER_CONTAINER_NAME="$2"
            shift # past argument
            shift # past value
            ;;
        --docker-container-tag)
            DOCKER_CONTAINER_TAG="$2"
            shift # past argument
            shift # past value
            ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo
echo " ** ** Running command in docker container ** ** "
echo " - - - - - - - "
echo " Docker mount path  : ${DOCKER_MOUNT_PATH}"
echo " Container          : ${DOCKER_CONTAINER_NAME}"
echo " Tag                : ${DOCKER_CONTAINER_TAG}"
echo " Command            : ${@}"
echo " - - - - - - - "
echo


# checks
if [[ -z "${DOCKER_MOUNT_PATH}" ]]
then

    echo "No docker mount path provided!"
    exit -1

fi

if [[ $# -lt 1 ]]
then

    echo "No command provided!"
    exit -1

fi


COMMON_PARAMS=()
COMMON_PARAMS+=("-e TF_FORCE_GPU_ALLOW_GROWTH=true")
COMMON_PARAMS+=("-u $(id -u):$(id -g)")
COMMON_PARAMS+=("--mount type=bind,target=${DOCKER_MOUNT_PATH},source=${DOCKER_MOUNT_PATH}")
COMMON_PARAMS+=("--rm")
COMMON_PARAMS+=("--workdir ${DOCKER_MOUNT_PATH}")


# launch
if [[ $(docker -v) == *" 18."* ]]
then

    docker run \
    	--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=${GPUS} \
    	${COMMON_PARAMS[@]} \
    	${DOCKER_CONTAINER_NAME}:${DOCKER_CONTAINER_TAG} \
    	${@}

else

    docker run \
    	--gpus device=${GPUS} \
    	${COMMON_PARAMS[@]} \
    	${DOCKER_CONTAINER_NAME}:${DOCKER_CONTAINER_TAG} \
    	${@}

fi
