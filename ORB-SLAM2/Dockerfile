FROM ubuntu:14.04
MAINTAINER David Gillsjo <david DOT gillsjo AT gmail DOT com>

# To build ORB_SLAM2 using this Docker image:
# docker run -v ~/docker/ORB_SLAM2/:/ORB_SLAM2/ -w=/ORB_SLAM2/ slam-test /bin/bash -c ./build.sh

# Arguments
ARG user=pspdocker
ARG uid=1000
ARG gid=1000

ENV OPENCV_VERSION 3.2.0
ENV OPENCV_DOWNLOAD_URL https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
ENV OpenCV_DIR opencv-$OPENCV_VERSION
ENV EIGEN_VERSION 3.3.2
ENV EIGEN_DOWNLOAD_URL http://bitbucket.org/eigen/eigen/get/$EIGEN_VERSION.tar.gz

RUN apt-get update && apt-get install -y \
	sudo \
	build-essential \
  cmake \
  curl \
  gcc \
  git \
  libglew-dev \
  libgtk2.0-dev \
  pkg-config \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  python-dev \
  python-numpy \
  unzip \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# install OpenCV
RUN curl -fsSL "$OPENCV_DOWNLOAD_URL" -o opencv.zip \
  && unzip opencv.zip \
  && rm opencv.zip \
  && cd $OpenCV_DIR \
  && mkdir release \
  && cd release \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
  && make \
  && make install

# install Eigen
RUN curl -fsSL "$EIGEN_DOWNLOAD_URL" -o eigen.tar.gz \
  && mkdir /usr/include/eigen \
  # rename first directory to be eigen instead of eigen-eigen-*
  && tar -xf eigen.tar.gz --strip-components=1 -C /usr/include/eigen \
  && rm eigen.tar.gz

# install Pangolin
RUN git clone https://github.com/stevenlovegrove/Pangolin.git \
  && cd Pangolin \
  && mkdir build \
  && cd build \
  && cmake .. \
  && make

# build ORB-SLAM2
RUN git clone https://github.com/raulmur/ORB_SLAM2.git ORB_SLAM2 \
  && cd ORB_SLAM2 \
  && chmod +x build.sh

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

WORKDIR "/ws"
RUN chown "${uid}:${gid}" "/ws"
USER "${uid}"

VOLUME data
VOLUME host_home

CMD ["bash"]
# Setup entrypoint
#COPY docker-entrypoint.sh /ws/docker-entrypoint.sh
#ENTRYPOINT ["/ws/docker-entrypoint.sh"]
