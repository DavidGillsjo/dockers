#!/bin/bash
USE_NVIDIA=1 IMAGE=${IMAGE-pytorch_mask_rcnn} ./../common/build.sh "$@"
