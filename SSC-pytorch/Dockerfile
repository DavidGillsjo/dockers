FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04

# Arguments
ARG user=pytorch
ARG uid=1000
ARG gid=1000
ARG gpu_arch=sm_61

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility

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
		libglu1-mesa-dev\
		pkg-config\
		libglvnd-dev\
		libgl1-mesa-dev\
		libegl1-mesa-dev\
		libgles2-mesa-dev\
		freeglut3-dev\
		mesa-common-dev\
		libosmesa6-dev\
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# ENV C_INCLUDE_PATH="${CUDA_HOME}/include:${C_INCLUDE_PATH}"
# ENV LIBRARY_PATH="${CUDA_HOME}/lib64:$LIBRARY_PATH"

#Install repo dependencies
RUN pip3 install --upgrade pip --no-cache-dir
RUN pip3 install --no-cache-dir\
		opencv-python-headless\
		torch \
		torchvision \
		tb-nightly \
		future \
		Cython \
		matplotlib \
		numpy \
		scipy \
		pyyaml \
		scikit-image \
		gitpython \
		sklearn \
		vispy

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

USER "${uid}"

# Setup entrypoint
# COPY docker-entrypoint.sh /ws/docker-entrypoint.sh
# ENTRYPOINT ["/ws/docker-entrypoint.sh"]
CMD bash

VOLUME data
VOLUME host_home
