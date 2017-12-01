#!/bin/bash
docker build\
  -t pspnet\
  --build-arg gid=$(id -g)\
  --build-arg uid=$(id -u)\
  --build-arg user="$USER"\
  "$@" .
