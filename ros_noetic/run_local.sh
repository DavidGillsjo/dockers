#!/bin/bash
#Usage: [ENV_OPTS] ./run_local [CMD] [ARGS]
IMAGE=${IMAGE-ros_noetic} ./../common/run.sh "$@"
