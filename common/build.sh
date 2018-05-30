#!/bin/bash

if [ -z $IMAGE ] ; then
  echo "Parameter IMAGE must be specified to name the image"
  exit
fi

if [ "${USE_NVIDIA}" == 1 ] ; then
  DOCKER_CALL="nvidia-docker"
else
  DOCKER_CALL="docker"
fi

MY_USER=${DUSER-$USER}

if [ -z $(id -g $MY_USER) ]
then #Check if user exists, if not use default uid, gid.
  BUILD_ARGS="--build-arg user=$MY_USER"
elif [ $(id -g $MY_USER) == 0 ]
then #Do not build container for sudo user, use default args.
  BUILD_ARGS=""
else
  BUILD_ARGS="--build-arg gid=$(id -g $MY_USER)\
              --build-arg uid=$(id -u $MY_USER)\
              --build-arg user=$MY_USER"
fi

#Copy the common folder to build context
cp -r ../common ./

echo ${IMAGE}
${DOCKER_CALL} build ${BUILD_ARGS}\
  -t ${IMAGE}\
   "$@" ${DOCKERFILE-.}
