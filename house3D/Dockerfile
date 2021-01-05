FROM nvidia/cuda:8.0-cudnn7-devel

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
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

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
