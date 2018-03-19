#!/bin/bash
set -e

#Check if bash command
if [ "$1" = 'bash' ]; then
  exec "$@"
elif [ "$1" = 'jupyter' ]; then
  /run_jupyter.sh --ip=0.0.0.0
else
  cd fcrn/tensorflow
  if [ -z "$2" ]; then
    python3 predict.py --help
  else
    python3 predict.py "$@"
  fi
fi
