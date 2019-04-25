# FCRN-DepthPrediction docker
This docker image is running a Tensorflow implementation of FCRN-DepthPrediction
from this fork: https://github.com/DavidGillsjo/FCRN-DepthPrediction.git

of the original repo:

https://github.com/iro-cp/FCRN-DepthPrediction.git.

It can be pulled from dockerhub or build locally.
Building locally enables you to clone your host machine user properly.

## Usage
See [a relative link](../README.md) for general usage. Some specific use cases below.

Batch process folder of jpg images mounted in DATA:
```
sudo DATA=<imgdir> DUSER=<myusername> ./run_local.sh NYU_FCRN.ckpt "/data/*.JPG" -o /data/<output_folder> -f mat,img
```

Start jupyter:
```
sudo DUSER=<myusername> ./run_local.sh jupyter
```
