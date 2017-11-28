FROM datmo/keras-tensorflow:gpu

# Get utils
RUN apt-get update && apt-get install -y git wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#Download code
RUN git clone https://github.com/DavidGillsjo/PSPNet-Keras-tensorflow.git pspnet &&\
    git checkout folder_support

#Model weights
RUN wget -nv "https://www.dropbox.com/s/ms8afun494dlh1t/pspnet50_ade20k.npy?dl=0" -O "pspnet/weights/npy/pspnet50_ade20k.npy"
RUN wget -nv "https://www.dropbox.com/s/b21j6hi6qql90l0/pspnet101_cityscapes.npy?dl=0" -O "pspnet/weights/npy/pspnet101_cityscapes.npy"
RUN wget -nv "https://www.dropbox.com/s/xkjmghsbn6sfj9k/pspnet101_voc2012.npy?dl=0" -O "pspnet/weights/npy/pspnet101_voc2012.npy"

VOLUME data

RUN chmod +x "/home/run_jupyter.sh"
CMD ["bash", "-c", "/home/run_jupyter.sh"]
