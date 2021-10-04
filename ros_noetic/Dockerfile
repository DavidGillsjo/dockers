FROM osrf/ros:noetic-desktop-full

RUN apt-get update && apt-get install -y \
  python3-pip \
  wget \
  unzip && \
  apt-get clean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*


RUN pip3 install \
pyquaternion

# Arguments
ARG user=noetic
ARG uid=1000
ARG gid=1000

# Add user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"


VOLUME /data
VOLUME /host_home

USER "${user}"

# Default powerline10k theme, no plugins installed
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)"

WORKDIR /host_home
CMD zsh
