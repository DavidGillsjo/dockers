#!/bin/bash
#Usage: [ENV_OPTS] ./run_local [CMD] [ARGS]
IMAGE=${IMAGE-orbslam2} ./../common/run.sh "$@"
