#!/bin/bash
set -e

#Check if bash command
if [ "$1" = 'bash' ]; then
  exec "$@"
elif [ "$1" = 'colmap' ]; then
  exec colmap "$@"
else
  exec python3 predict.py "$@"
fi
