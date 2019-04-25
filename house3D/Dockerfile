FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04
# Arguments
ARG user=docker
ARG uid=1000
ARG gid=1000
ARG gpu_arch=sm_52

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
	numpy\
	opencv-python-headless\
	tqdm\
	pyyaml\
	git+git://github.com/waspinator/pycococreator.git@0.2.0\
	Cython\
	matplotlib
#Numpy prereq for scikit-fmm
RUN pip3 install\
	scikit-fmm\
	pycocotools

#SSC stuff
RUN pip3 install\
	shapely\
	pywavefront


VOLUME data
VOLUME host_home

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

USER "${uid}"

# Setup entrypoint
CMD bash
