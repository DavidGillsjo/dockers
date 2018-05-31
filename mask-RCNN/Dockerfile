FROM nvidia/cuda:8.0-cudnn7-devel

# Arguments
ARG user=pytorch
ARG uid=1000
ARG gid=1000
ARG gpu_arch=sm_61

# Install some dependencies
RUN apt-get update && apt-get install -y \
		wget\
    git\
		python3.5-tk\
    python3-pip\
    sudo\
		vim\
		unzip\
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# gdrive dependency
RUN pip3 install requests

#Install repo dependencies
ADD https://raw.githubusercontent.com/lichengunc/mask-faster-rcnn/master/requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN pip3 install cffi

WORKDIR "/ws"
# Changes when we update the repo, forces docker to clone the code and not use cache.
ADD https://api.github.com/repos/lichengunc/mask-faster-rcnn/git/refs/heads/master version.json
#Download code
RUN git clone --recursive https://github.com/lichengunc/mask-faster-rcnn


#Get weights
COPY common/google_drive.py .
RUN mkdir -p mask-faster-rcnn/data/imagenet_weights &&\
  	python3 google_drive.py "0B7fNdx_jAqhtaXZ4aWppWV96czg" "mask-faster-rcnn/data/imagenet_weights/res101.pth"
RUN mkdir -p "mask-faster-rcnn/output/res101/coco_2014_train_minus_refer_valtest+coco_2014_valminusminival/notime" &&\
		cd "mask-faster-rcnn/output/res101/coco_2014_train_minus_refer_valtest+coco_2014_valminusminival/notime" &&\
		wget -nv "http://bvision.cs.unc.edu/licheng/MattNet/pytorch_mask_rcnn/res101_mask_rcnn_iter_1250k.zip" &&\
		unzip -q "res101_mask_rcnn_iter_1250k.zip"


#Link python to python3
RUN echo -e '#!/bin/bash\npython3 "$@"' > /usr/bin/python && \
    chmod +x /usr/bin/python

#Build stuff
RUN cd mask-faster-rcnn/lib &&\
		make

#All users can run the code (in case the --user argument is used at runtime to have access to data.)
RUN chmod -R o+rw mask-faster-rcnn

VOLUME data
VOLUME host_home

# Setup user
RUN export uid="${uid}" gid="${gid}" && \
    groupadd -g "${gid}" "${user}" && \
    useradd -m -u "${uid}" -g "${user}" -s /bin/bash "${user}" && \
    passwd -d "${user}" && \
    usermod -aG sudo "${user}"

RUN chown -R "${uid}:${gid}" "/ws"
USER "${uid}"

# Setup entrypoint
COPY docker-entrypoint.sh /ws/docker-entrypoint.sh
ENTRYPOINT ["/ws/docker-entrypoint.sh"]
