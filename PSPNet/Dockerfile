FROM tensorflow/tensorflow:latest-gpu-py3

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

WORKDIR "/workspace"
RUN chown "${user}" "/workspace"
USER "${user}"

#Download code
RUN git clone -b folder_support https://github.com/DavidGillsjo/PSPNet-Keras-tensorflow.git pspnet
#All users can run the code (in case the --user argument is used at runtime to have access to data.)
RUN chmod -R o+rw pspnet

#Model weights
RUN wget -nv "https://www.dropbox.com/s/ms8afun494dlh1t/pspnet50_ade20k.npy?dl=0" -O "pspnet/weights/npy/pspnet50_ade20k.npy"
RUN wget -nv "https://www.dropbox.com/s/b21j6hi6qql90l0/pspnet101_cityscapes.npy?dl=0" -O "pspnet/weights/npy/pspnet101_cityscapes.npy"
RUN wget -nv "https://www.dropbox.com/s/xkjmghsbn6sfj9k/pspnet101_voc2012.npy?dl=0" -O "pspnet/weights/npy/pspnet101_voc2012.npy"

VOLUME data
VOLUME host_home


CMD ["/run_jupyter.sh", "--ip=0.0.0.0"]
