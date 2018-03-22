FROM tensorflow/tensorflow:1.4.1-gpu-py3

# Arguments
ARG user=pspdocker
ARG uid=1000
ARG gid=1000

# Install some dependencies
RUN apt-get update && apt-get install -y \
		wget\
    git\
    python3-tk\
    sudo\
		vim\
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# Install Keras
RUN pip3 install h5py
RUN pip3 --no-cache-dir install git+git://github.com/fchollet/keras.git

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

WORKDIR "/ws"
RUN chown "${uid}:${gid}" "/ws"
USER "${uid}"

# Changes when we update the repo, forces docker to clone the code and not use cache.
ADD https://api.github.com/repos/DavidGillsjo/PSPNet-Keras-tensorflow/git/refs/heads/devel version.json
#Download code
RUN git clone -b devel https://github.com/DavidGillsjo/PSPNet-Keras-tensorflow.git pspnet
#All users can run the code (in case the --user argument is used at runtime to have access to data.)
RUN chmod -R o+rw pspnet

#Model weights
RUN wget -nv "https://www.dropbox.com/s/0uxn14y26jcui4v/pspnet50_ade20k.h5?dl=1" -O "pspnet/weights/keras/pspnet50_ade20k.h5"
RUN wget -nv "https://www.dropbox.com/s/v41lvku2lx7lh6m/pspnet50_ade20k.json?dl=1" -O "pspnet/weights/keras/pspnet50_ade20k.json"
RUN wget -nv "https://www.dropbox.com/s/c17g94n946tpalb/pspnet101_cityscapes.h5?dl=1" -O "pspnet/weights/keras/pspnet101_cityscapes.h5"
RUN wget -nv "https://www.dropbox.com/s/fswowe8e3o14tdm/pspnet101_cityscapes.json?dl=1" -O "pspnet/weights/keras/pspnet101_cityscapes.json"
RUN wget -nv "https://www.dropbox.com/s/uvqj2cjo4b9c5wg/pspnet101_voc2012.h5?dl=1" -O "pspnet/weights/keras/pspnet101_voc2012.h5"
RUN wget -nv "https://www.dropbox.com/s/rr5taqu19f5fuzy/pspnet101_voc2012.json?dl=1" -O "pspnet/weights/keras/pspnet101_voc2012.json"

VOLUME data
VOLUME host_home

# Setup entrypoint
COPY docker-entrypoint.sh /ws/docker-entrypoint.sh
ENTRYPOINT ["/ws/docker-entrypoint.sh"]
