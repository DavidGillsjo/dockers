FROM nvidia/cuda:8.0-cudnn7-devel

# Arguments
ARG user=pytorch
ARG uid=1000
ARG gid=1000
ARG gpu_arch=sm_61

# Install some dependencies
RUN apt-get update && apt-get install -y \
		wget\
    git\
		python3.5-tk\
    python3-pip\
    sudo\
		vim\
		unzip\
		libgtk2.0\
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# gdrive dependency
RUN pip3 install requests
#Install repo dependencies
RUN pip3 install \
		opencv-python-headless\
		cffi \
		#Detectron only works with Torch 0.4.0
		torch==0.4.0 \
		torchvision \
		Cython \
		matplotlib \
		numpy \
		scipy \
		pyyaml \
		packaging \
		tensorflow \
		tensorboardX \
		argparse-color-formatter \
		git+git://github.com/waspinator/pycococreator.git@0.2.0 \
		colorama
RUN pip3 install pycocotools

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

# ------------- Skip for now, we will use code on host --------------
# WORKDIR "/ws"
# # Changes when we update the repo, forces docker to clone the code and not use cache.
# ADD https://api.github.com/repos/roytseng-tw/Detectron.pytorch/git/refs/heads/master version.json
# #Download code
# RUN git clone --recursive https://github.com/roytseng-tw/Detectron.pytorch.git detectron
#
# #Create data mkdir
# RUN mkdir -p detectron/data/pretrained_model
#
# #Get weights
# RUN cd detectron &&\
# 		python3 tools/download_imagenet_weights.py
# RUN wget -nv \
# 		"https://s3-us-west-2.amazonaws.com/detectron/35861858/12_2017_baselines/e2e_mask_rcnn_R-101-FPN_2x.yaml.02_32_51.SgT4y1cO/output/train/coco_2014_train%3Acoco_2014_valminusminival/generalized_rcnn/model_final.pkl" \
# 		-O detectron/data/pretrained_model/e2e_mask_rcnn_R-101-FPN_2x.pkl
#
# #Build stuff
# RUN cd detectron/lib &&\
# 		sh make.sh
#
# #All users can run the code (in case the --user argument is used at runtime to have access to data.)
# RUN chmod -R o+rw detectron
# RUN chown -R "${uid}:${gid}" "/ws"
# --------------------------------------------------------------------

USER "${uid}"

# Setup entrypoint
# COPY docker-entrypoint.sh /ws/docker-entrypoint.sh
# ENTRYPOINT ["/ws/docker-entrypoint.sh"]
CMD bash

VOLUME data
VOLUME host_home
