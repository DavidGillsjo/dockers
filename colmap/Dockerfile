FROM nvidia/cuda:10.1-cudnn7-devel
# Arguments
ARG user=docker
ARG uid=1000
ARG gid=1000

# Install some dependencies
RUN apt-get update && apt-get install -y --allow-unauthenticated \
		sudo \
		python3 \
		python3-pip \
		git \
		cmake \
		build-essential \
		libboost-program-options-dev \
		libboost-filesystem-dev \
		libboost-graph-dev \
		libboost-regex-dev \
		libboost-system-dev \
		libboost-test-dev \
		libeigen3-dev \
		libsuitesparse-dev \
		libfreeimage-dev \
		libgoogle-glog-dev \
		libgflags-dev \
		libglew-dev \
		qtbase5-dev \
		libqt5opengl5-dev \
		libcgal-dev \
		libcgal-qt5-dev \
		# Ceres
		libatlas-base-dev \
		libsuitesparse-dev \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip
RUN pip3 install\
		matplotlib \
		scipy \
		pyquaternion \
		numpy

# Install ceres
ADD https://api.github.com/repos/ceres-solver/ceres-solver/git/refs/heads/master version_ceres.json
RUN git clone https://ceres-solver.googlesource.com/ceres-solver
RUN cd ceres-solver &&\
		git checkout $(git describe --tags) &&\
		mkdir build &&\
		cd build &&\
		cmake .. -DBUILD_TESTING=OFF -DBUILD_EXAMPLES=OFF &&\
		make -j"$(( $(nproc) / 2))" &&\
		make install

#Install colmap
ADD https://api.github.com/repos/colmap/colmap/git/refs/heads/master version_colmap.json
RUN git clone https://github.com/colmap/colmap.git --branch master
RUN cd colmap &&\
		mkdir build &&\
		cd build &&\
		cmake .. &&\
		make -j"$(( $(nproc) / 2))" &&\
		make install
RUN chown -R  "${uid}" colmap
ENV PYTHONPATH="$PYTHONPATH:/colmap/scripts/python"

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
COPY run_colmap.py /
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["--help"]
