FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu18.04

# Arguments
ARG user=pytorch
ARG uid=1000
ARG gid=1000

#Default GPU arch, can be changed later
ENV GPU_ARCH=sm_70

#Remove interative elements from apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Install some dependencies
RUN apt-get update && apt-get install -y \
		wget\
    git\
		python3\
    python3-pip\
    sudo\
		vim\
		unzip\
		libgtk2.0\
		libsm6\
		libxext6\
		libxrender-dev\
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

#nvcc --version
#Must match:
#import torch
#torch.version.cuda
#Get pytorch for cuda9.2
ARG pytorch_wheel="torch-0.4.1-cp36-cp36m-linux_x86_64.whl"
RUN wget -nv "https://download.pytorch.org/whl/cu92/$pytorch_wheel"
RUN pip3 install "$pytorch_wheel"

# Repo requirements
RUN wget -nv https://raw.githubusercontent.com/NVlabs/planercnn/master/requirements.txt
RUN pip3 install -r requirements.txt
RUN pip3 install h5py

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

USER "${uid}"

COPY build_repo.sh .

CMD bash

VOLUME data
VOLUME host_home
