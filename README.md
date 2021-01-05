# dockers
Collection of Dockerfiles wrapped in some convenient run and build scripts.

## Dependencies
Most images are built to run on a GPU and requires both [docker](https://docs.docker.com/get-started/)
and [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) together with NVIDIA drivers.

## Build
Simply run `./build.sh`.

This will setup a cloned user in the image.
If you need to use `sudo` to run docker, run this to clone your user `<myusername>`:
```
sudo DUSER=<myusername> ./build.sh
```
If you want to name the image differently from default, use the `IMAGE` argument.

## Run locally
After building, run the image with:
- `./run_local.sh` for the application
- `./run_local.sh jupyter` for jupyter server (works for some)
- `./run_local.sh bash` for interactive bash prompt

There are some optional arguments here:
- `DATA=<datadir>` allows you to mount a data directory which you access from within the container as `/data`.
- `DHOME=<homedir>` allows you to mount a home directory which you access from within the container as `/host_home`, defaults to `$HOME`.
- `DUSER=<myuser>` allows you to run the container as another user than the user executing the script
- `IMAGE=<image name>` in case you named your image differently from default name.

For example, mounting the data directory `/home/$USER/data` on the host and running as root:
```
DATA=/home/$USER/data DUSER=root ./run_local.sh bash
```

Or if you need to use `sudo` to run docker but want to run the container as your user `<myusername>`:
```
sudo DUSER=<myusername> ./run_local.sh bash
```

## Pull from dockerhub and run
Fastest way to get started, simply run `./run_dockerhub.sh`.
Same options as above.
