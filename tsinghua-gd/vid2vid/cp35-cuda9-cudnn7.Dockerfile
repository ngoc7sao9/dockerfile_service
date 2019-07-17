FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get update && apt-get install -y rsync htop git openssh-server

RUN apt-get install python3-pip -y
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip3 install --upgrade pip

#Torch and dependencies:
RUN pip install http://download.pytorch.org/whl/cu90/torch-0.4.1-cp35-cp35m-linux_x86_64.whl 
RUN pip install torchvision==0.2.2 cffi tensorboardX
RUN pip install tqdm scipy scikit-image colorama==0.3.7 
RUN pip install setproctitle pytz ipython

#vid2vid dependencies
RUN apt-get install libglib2.0-0 libsm6 libxrender1 -y
RUN pip install dominate requests opencv-python==3.4.5.20

#pix2pixHD, required for initializing training
RUN git clone https://github.com/NVIDIA/pix2pixHD /pix2pixHD

#vid2vid install
RUN git clone https://github.com/NVIDIA/vid2vid /vid2vid
WORKDIR /vid2vid
#download flownet2 model dependencies
#WARNING: we had an instance where these scripts needed to be re-run after the docker instance was launched
RUN python scripts/download_flownet2.py
RUN python scripts/download_models_flownet2.py

# 安装基础库
RUN pip install --upgrade pip \
    && pip install -U setuptools \
    && pip --no-cache-dir install \
        numpy \
        pandas \
        scipy \
        scikit-learn \
        jupyterlab \
        tqdm \
        matplotlib \
        imgaug

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    wget
