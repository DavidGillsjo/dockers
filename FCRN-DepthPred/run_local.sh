#!/bin/bash
#Usage: [ENV_OPTS] ./run_local [CMD] [ARGS]
IMAGE=${IMAGE-fcrn} ./../common/run.sh "$@"
