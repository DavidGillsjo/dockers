#!/bin/bash

if [ -z $IMAGE ] ; then
  echo "Parameter IMAGE must be specified to name the image"
  exit
fi

MY_USER=${DUSER-$USER}

if [ -z $(id -g $MY_USER)]
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

echo ${IMAGE}
docker build ${BUILD_ARGS}\
  -t ${IMAGE}\
   "$@" ${DOCKERFILE-.}
