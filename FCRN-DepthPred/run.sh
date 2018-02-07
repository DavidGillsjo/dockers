#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]

# Use $USER unless run with sudo
if [ -z $DUSER ] ; then
  if [ $(id -g $USER) == 0 ] ; then
    USER_OPT=""
  else
    USER_OPT="-u $(id -u $USER):$(id -g $USER)"
  fi
else
  USER_OPT="-u $(id -u $DUSER):$(id -g $DUSER)"
fi

# Use $HOME unless run with sudo
if [ -z $DHOME ] ; then
  if [ $(id -g $USER) == 0 ] ; then
    HOME_OPT=""
  else
    HOME_OPT="-v ${HOME}:/workspace/host_home:rw"
  fi
else
  HOME_OPT="-v ${DHOME}:/workspace/host_home:rw"
fi

nvidia-docker run --rm -it \
        --name=pspnet\
        -v "${DATA-/tmp/data}:/workspace/data:rw"\
        -p "8888:8888"\
        ${USER_OPT}\
        ${HOME_OPT}\
        "${IMAGE-fcrn}" "$@"
