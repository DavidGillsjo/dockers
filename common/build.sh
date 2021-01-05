#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

if [ -z $IMAGE ] ; then
  echo "Parameter IMAGE must be specified to name the image"
  exit
fi

#Need to run with sudo? Useful for getting the USER options correctly detected.
if [ -z $SUDO ] ; then
  SUDO_OPT=""
else
  SUDO_OPT="sudo"
fi

MY_USER=${DUSER-$USER}
MY_HOME=$(eval echo "~$MY_USER")

if [ -z $(id -g $MY_USER) ]
then #Check if user exists, if not use default uid, gid.
  BUILD_ARGS="--build-arg user=$MY_USER"
elif [ $(id -g $MY_USER) == 0 ]
then #Do not build container for sudo user, use default args.
  echo "------------------------------------------
You are building the container for root user.
Mounting and X forward will not work as intended.
If you need to use sudo, run:
${bold}SUDO=1 ./build.sh${normal}

Proceed with build?"
  select yn in "Yes" "No"; do
    case $yn in
        Yes ) break;;
        No ) exit;;
    esac
  done
  BUILD_ARGS=""
else
  BUILD_ARGS="--build-arg gid=$(id -g $MY_USER)\
              --build-arg uid=$(id -u $MY_USER)\
              --build-arg user=$MY_USER"
fi

#Copy SSH keys to local build context, create empty if not existing
KEY_FILE="${MY_HOME}/.ssh/authorized_keys"
if [ -e ${KEY_FILE} ]
then
  cp ${KEY_FILE} .
else
  touch authorized_keys
fi

#Copy the common folder to build context
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cp -r "${SCRIPTDIR}/../common" ./

${SUDO_OPT} docker build ${BUILD_ARGS}\
  -t ${IMAGE}\
   "$@" ${DOCKERFILE-.}

 # Remove what we added
rm -r common authorized_keys
