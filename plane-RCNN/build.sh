#!/bin/bash
USE_NVIDIA=1 IMAGE=${IMAGE-plane_rcnn} ./../common/build.sh "$@"
