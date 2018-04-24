#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]

#X Display stuff
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

if [ -z $IMAGE ] ; then
  echo "Parameter IMAGE must be specified to choose the image"
fi

if [ "${USE_NVIDIA}" == 1 ] ; then
  DOCKER_CALL="nvidia-docker"
  XDISPLAY_OPT=""
else
  DOCKER_CALL="docker"
  XDISPLAY_OPT="--volume=/dev/dri:/dev/dri:rw \
                --volume=$XAUTH:$XAUTH:rw \
                --env=XAUTHORITY=${XAUTH} \
                --volume=$XSOCK:$XSOCK:rw \
                --env=DISPLAY \
                --env='QT_X11_NO_MITSHM=1'"
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
        ${XDISPLAY_OPT}\
        "${IMAGE}" "$@"
