FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04
# Arguments
ARG user=docker
ARG uid=1000
ARG gid=1000
ARG gpu_arch=sm_61

# Install some dependencies
RUN apt-get update && apt-get install -y \
		wget\
    git\
		python3\
    python3-pip\
    sudo\
		vim\
		libglfw3-dev\
		libglm-dev\
		libx11-dev\
		libegl1-mesa-dev\
		libpng-dev\
		libjpeg-dev\
		pkg-config\
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# Python dependencies
RUN pip3 install\
	opencv-python-headless\
	tqdm

RUN git clone https://github.com/facebookresearch/House3D.git
RUN cd House3D && \
		pip3 install .

VOLUME data
VOLUME host_home

#Nvidia EGL support
# ENV NVIDIA_DRIVER_CAPABILITIES=compute,graphics,utility,video
# LABEL com.nvidia.volumes.needed="nvidia_driver"
# ENV PATH /usr/local/nvidia/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# No need for interactive backend in matplotlib
#ENV MPLBACKEND "Agg"

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

USER "${uid}"

# Setup entrypoint
CMD bash
