#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]

if [ -z $IMAGE ] ; then
  echo "Parameter IMAGE must be specified to choose the image"
fi

if [ "${USE_NVIDIA}" == 1 ] ; then
  DOCKER_CALL="nvidia-docker"
else
  DOCKER_CALL="docker"
fi

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
    HOME_OPT="-v ${HOME}:/host_home:rw"
  fi
else
  HOME_OPT="-v ${DHOME}:/host_home:rw"
fi

#Container name specified?
if [ -z $CNAME ] ; then
  NAME_OPT="--name=${CNAME}"
else
  NAME_OPT=""
fi
echo
#Run!
${DOCKER_CALL} run --rm -it \
        ${NAME_OPT}\
        -v "${DATA-/tmp/data}:/data:rw"\
        -p "8000-9000:8888"\
        ${USER_OPT}\
        ${HOME_OPT}\
        "${IMAGE}" "$@"
