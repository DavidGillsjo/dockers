#!/bin/bash
#Usage: [ENV_OPTS] ./run_dockerhub [CMD] [ARGS]
USE_NVIDIA=1 IMAGE="davidgillsjo/fcrn" ./../common/run.sh "$@"
