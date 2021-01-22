#!/bin/bash
USE_NVIDIA=1 IMAGE=${IMAGE-hawp} ./../common/build.sh "$@"
