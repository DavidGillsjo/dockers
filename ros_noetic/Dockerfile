FROM osrf/ros:noetic-desktop-full

RUN apt-get update && apt-get install -y \
  python3-pip \
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
