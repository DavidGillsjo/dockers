#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]
MYUID=$(id -u $USER)
MYGID=$(id -g $USER)
nvidia-docker run --rm -it \
        --name=pspnet\
        -v "${DATA-/tmp/data}:/workspace/data:rw"\
        -p "8888:8888"\
        -u "$MYUID:$MYGID"\
        "${IMAGE-pspnet}" "$@"
