#!/bin/bash
USE_NVIDIA=1 IMAGE=${IMAGE-pytorch_scc_net} ./../common/build.sh "$@"
