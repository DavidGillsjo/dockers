#!/bin/bash
#Usage: [ENV_OPTS] ./run [CMD] [ARGS]
nvidia-docker run --rm -it \
        --name=pspnet\
        -v "${DATA-/tmp/data}:/workspace/data:rw"\
        -p "8888:8888"\
        "davidgillsjo/pspnet" "$@"
