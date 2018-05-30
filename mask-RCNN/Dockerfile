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
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*

# Torch stuff
RUN pip3 install torch torchvision numpy scipy matplotlib scikit-image h5py cffi
# Coco stuff
RUN pip3 install Cython
RUN pip3 install pycocotools
# gdrive dependency
RUN pip3 install requests

WORKDIR "/ws"
# Changes when we update the repo, forces docker to clone the code and not use cache.
ADD https://api.github.com/repos/multimodallearning/pytorch-mask-rcnn/git/refs/heads/master version.json
#Download code
RUN git clone https://github.com/multimodallearning/pytorch-mask-rcnn

#Get weights
COPY common/google_drive.py .
RUN python3 google_drive.py "1VV6WgX_RNl6a9Yi9-Pe7ZyVKHRJZSKkm" "pytorch-mask-rcnn/mask_rcnn_coco.pth"
RUN python3 google_drive.py "12veVlnggRRaghRRyDIWTQkuxT8WSzIw6" "pytorch-mask-rcnn/resnet50_imagenet.pth"

#Build stuff
RUN cd pytorch-mask-rcnn/nms/src/cuda/ &&\
    nvcc -c -o nms_kernel.cu.o nms_kernel.cu -x cu -Xcompiler -fPIC -arch="${gpu_arch}" &&\
    cd ../../ &&\
    python3 build.py &&\
    cd ../
RUN cd pytorch-mask-rcnn/roialign/roi_align/src/cuda/ &&\
    nvcc -c -o crop_and_resize_kernel.cu.o crop_and_resize_kernel.cu -x cu -Xcompiler -fPIC -arch="${gpu_arch}" &&\
  	cd ../../ &&\
    python3 build.py &&\
    cd ../../
#All users can run the code (in case the --user argument is used at runtime to have access to data.)
RUN chmod -R o+rw pytorch-mask-rcnn

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
