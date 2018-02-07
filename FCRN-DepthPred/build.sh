#!/bin/bash

MY_USER=${DUSER-$USER}

#Do not build container for sudo user, use default args.
if [ $(id -g $MY_USER) == 0 ] ; then
  BUILD_ARGS=""
else
  BUILD_ARGS="--build-arg gid=$(id -g $MY_USER)\
              --build-arg uid=$(id -u $MY_USER)\
              --build-arg user=$MY_USER"
fi

docker build ${BUILD_ARGS}\
  -t fcrn\
   "$@" .
