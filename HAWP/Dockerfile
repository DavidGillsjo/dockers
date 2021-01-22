FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04

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

# Install torch
RUN pip3 install --upgrade pip --no-cache-dir \
	scikit-build

RUN pip3 install --upgrade pip --no-cache-dir \
	torch\
	torchvision\
	opencv-python-headless\
	cython\
	matplotlib\
	yacs\
	scikit-image\
	requests\
	tqdm

#Include start scripts
COPY clone_and_build.sh .
COPY common/google_drive.py .
RUN chmod +rx clone_and_build.sh google_drive.py

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

USER "${uid}"
VOLUME data
VOLUME host_home

# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"

WORKDIR /host_home
CMD zsh
