# COLMAP docker
This docker image is running colmap from https://github.com/colmap/colmap.git.

##Usage
See [a relative link](../README.md) for general usage. Some specific use cases below.

Batch process some folders placed in 'data/*/raw':
```
sudo DATA=<imgdir> DUSER=<myusername> ./run_local.sh /data --folder-pattern '*/raw'
```
