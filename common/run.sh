#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]
#X Display stuff

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
#If using X forwarding we must replace localhost with docker host IP.
#Note that the host SSH server must have configured "X11UseLocalhost no".
DISPLAY=`echo $DISPLAY | sed 's/^[^:][^:]+\(.*\)/172.17.0.1\1/'`
XDISPLAY_OPT="--volume=/dev/dri:/dev/dri:rw \
              --volume=$XAUTH:$XAUTH:rw \
              --env=XAUTHORITY=${XAUTH} \
              --volume=$XSOCK:$XSOCK:rw \
              --env=DISPLAY \
              --env='QT_X11_NO_MITSHM=1'"

if [ -z $IMAGE ] ; then
  echo "Parameter IMAGE must be specified to choose the image"
fi

if [ "${USE_NVIDIA}" == 1 ] ; then
  NVIDIA_ARGS="--gpus all"
  SHM_OPT="--shm-size 8G"
else
  NVIDIA_ARGS=""
  SHM_OPT=""
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

#SSH port specified? See ssh_forward for usage.
if [[ -v SSH_PORT ]] ; then
  SSH_OPT="-p ${SSH_PORT}:22"
else
  SSH_OPT=""
fi

#Mount git preferences if running as user
if [[ $(id -g $USER) != 0 ]] && [[ -e "${HOME}/.gitconfig" ]] ; then
  GIT_OPT="-v ${HOME}/.gitconfig:/home/$USER/.gitconfig:ro"
else
  GIT_OPT=""
fi

#Mount ssh keys if running as user
if [[ $(id -g $USER) != 0 ]] && [[ -e "${HOME}/.ssh" ]] ; then
  SSH_KEY_OPT="-v ${HOME}/.ssh:/home/$USER/.ssh:ro"
else
  SSH_KEY_OPT=""
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

#Need to run with sudo? Useful for getting the HOME and USER options correctly detected.
if [ -z $SUDO ] ; then
  SUDO_OPT=""
else
  SUDO_OPT="sudo"
fi

#Pull image before running
if [ "${PULL}" == 1 ] ; then
  ${SUDO_OPT} docker pull ${IMAGE}
fi

#Run!
#Ports:
#6006 -> Tensorflow
# -p "0.0.0.0:6000-7000:6006"\
${SUDO_OPT} docker run --rm -it \
        ${NAME_OPT}\
        -v "${DATA-/tmp/data}:/data:rw"\
        -v "/etc/localtime:/etc/localtime:ro"\
        -p "8001-9000:8888"\
        ${USER_OPT}\
        ${SSH_OPT}\
        ${NVIDIA_ARGS}\
        ${HOME_OPT}\
        ${GIT_OPT}\
        ${SSH_KEY_OPT}\
        ${XDISPLAY_OPT}\
        ${SHM_OPT}\
        "${IMAGE}" "$@"
