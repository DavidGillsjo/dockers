#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]
nvidia-docker run --rm -it \
        --name=${DOCKER_NAME}\
        -v "${DATA-/tmp/data}:/workspace/data:rw"\
        -p "8888:8888"\
        pspnet "$@"
