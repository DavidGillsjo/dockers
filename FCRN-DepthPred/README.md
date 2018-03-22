# FCRN-DepthPrediction docker
This docker image is running a Tensorflow implementation of FCRN-DepthPrediction
from this fork: https://github.com/DavidGillsjo/FCRN-DepthPrediction.git

of the original repo:

https://github.com/iro-cp/FCRN-DepthPrediction.git.

It can be pulled from dockerhub or build locally.
Building locally enables you to clone your host machine user properly.

## Dependencies
The image is built to run on a GPU and requires [docker](https://docs.docker.com/get-started/)
and [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

## Build
Simply run `./build.sh`.

This will setup a cloned user in the image.
If you need to use `sudo` to run docker, run this to clone your user `<myusername>`:
```
sudo DUSER=<myusername> ./build.sh
```

## Run locally
After building, run the image with:
- `./run_local.sh` for pspnet.py
- `./run_local.sh bash` for interactive bash prompt

There are some optional arguments here:
- `DATA=<datadir>` allows you to mount a data directory which you access from within the container as `/data`.
- `DHOME=<homedir>` allows you to mount a home directory which you access from within the container as `/host_home`, defaults to `$HOME`.
- `DUSER=<myuser>` allows you to run the container as another user than the user executing the script

For example, mounting the data directory `/home/$USER/data` on the host and running as root:
```
DATA=/home/$USER/data DUSER=root ./run_local.sh bash
```

Or if you need to use `sudo` to run docker but want to run the container as your user `<myusername>`:
```
sudo DUSER=<myusername> ./run_local.sh bash
```

Batch process folder of jpg images mounted in DATA:
```
sudo DATA=<imgdir> DUSER=<myusername> ./run_local.sh NYU_FCRN.ckpt "/data/*.JPG" -o /data/<output_folder> -f mat,img
```

Start jupyter:
```
sudo DUSER=<myusername> ./run_local.sh jupyter
```

## Pull from dockerhub and run
Fastest way to get started, simply run `./run_dockerhub.sh`.
Same options as above.
