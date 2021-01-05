#!/bin/bash
#Usage: [ENV_OPTS] ./run_local [CMD] [ARGS]
USE_NVIDIA=1 SSH_PORT=2201 IMAGE=${IMAGE-ssh_firefox} ./../common/run.sh "$@"
