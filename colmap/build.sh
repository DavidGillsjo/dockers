#!/bin/bash
USE_NVIDIA=1 IMAGE=${IMAGE-colmap} ./../common/build.sh "$@"
