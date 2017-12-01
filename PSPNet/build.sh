#!/bin/bash

#Do not build container for sudo user, use default args.
if [ $(id -g $USER) == 0 ] ; then
  BUILD_ARGS=""
else
  BUILD_ARGS="--build-arg gid=$(id -g)\
              --build-arg uid=$(id -u)\
              --build-arg user=$USER"
fi

docker build ${BUILD_ARGS}\
  -t pspnet\
   "$@" .
