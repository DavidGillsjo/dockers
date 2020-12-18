#!/bin/bash
USE_NVIDIA=1 IMAGE=${IMAGE-ssh_firefox} ./../common/build.sh "$@"
