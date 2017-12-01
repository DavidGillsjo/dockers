# PSPNet docker
This docker image is running a Keras/Tensorflow implementation of PSPNet
from this fork https://github.com/DavidGillsjo/PSPNet-Keras-tensorflow.git of
the original repo https://github.com/Vladkryvoruchko/PSPNet-Keras-tensorflow.

It can be pulled from dockerhub or build locally.
Building locally enables you to clone your host machine user properly.

## Build
Simple run ´./build.sh´.

This will setup a cloned user in the image.

## Run locally
After building, run the image with:
- ´./run_local.sh´ for jupyter notebook
- ´./run_local.sh bash´ for interactive bash prompt
There are two optional arguments here:
- ´DATA=<datadir>´ allows you to mount a data directory which you access from within the container.
- ´USER=<myuser>´ allows you to run the container as another user than the user executing the script

For example, mounting the data directory ´/home/$USER/data´ on the host and running as root:

´DATA=/home/$USER/data USER=root ./run_local.sh bash´

Or if you need to use ´sudo´ to run docker but want to run the container as your user ´<myusername>´:

´USER=<myusername> ./run_local.sh bash´

## Pull from dockerhub and run
Fastest way to get started, simply run ´./run_dockerhub.sh´.
Same options as above.
