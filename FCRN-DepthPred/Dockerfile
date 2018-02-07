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
RUN git clone -b devel https://github.com/DavidGillsjo/FCRN-DepthPrediction.git fcrn
#All users can run the code (in case the --user argument is used at runtime to have access to data.)
RUN chmod -R o+rw pspnet

#Model weights
RUN wget -nv "http://campar.in.tum.de/files/rupprecht/depthpred/NYU_FCRN-checkpoint.zip" -O "fcrn/tensorflow/m.zip"
RUN unzip "fcrn/tensorflow/m.zip" "fcrn/tensorflow/"

VOLUME data
VOLUME host_home


CMD ["/run_jupyter.sh", "--ip=0.0.0.0"]
