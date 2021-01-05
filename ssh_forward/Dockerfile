FROM ubuntu

ARG user=pytorch
ARG uid=1000
ARG gid=1000

#To enable Nvidia graphics using nvidia docker
#ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility

RUN apt update \
    && apt install -y firefox \
                      openssh-server \
                      xauth \
                      sudo \
    && mkdir /var/run/sshd \
    && mkdir /root/.ssh \
    && chmod 700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

COPY authorized_keys /root/.ssh/authorized_keys

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

#Put key in user folder
RUN mkdir "/home/${user}/.ssh" \
    && ssh-keygen -A
COPY authorized_keys "/home/${user}/.ssh/authorized_keys"
RUN chown -R "${user}" "/home/${user}/.ssh"

#Start SSH service
RUN service ssh start

# Switch to user
USER "${uid}"



CMD bash
