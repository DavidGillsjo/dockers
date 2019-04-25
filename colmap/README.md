# PSPNet docker
This docker image is running a Keras/Tensorflow implementation of PSPNet
from this fork: https://github.com/DavidGillsjo/PSPNet-Keras-tensorflow.git

of the original repo:

https://github.com/Vladkryvoruchko/PSPNet-Keras-tensorflow.

##Usage
See [a relative link](../README.md) for general usage. Some specific use cases below.

Batch process folder of jpg images mounted in DATA and skip rescaling (for increased speed):
```
sudo DATA=<imgdir> DUSER=<myusername> ./run_local.sh -g "/data/*.jpg" -o /data/<outdir> -m pspnet50_ade20k -ns
```

Start jupyter:
```
sudo DUSER=<myusername> ./run_local.sh jupyter
```
