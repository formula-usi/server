FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu22.04
 
WORKDIR /home
 
RUN apt-get update \
    && apt-get install -y wget --no-install-recommends g++ gcc ca-certificates \
    && apt-get install -y git \
    && git clone https://github.com/autorope/donkeycar.git \
    && cd donkeycar \
    && git checkout a91f88d
 
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
 
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh \
    && echo "Running $(conda --version)" \
    && conda init bash \
    && . /root/.bashrc \
    && conda update conda \
    && conda update -n base -c defaults conda \
    && conda install mamba -n base -c conda-forge \
    && mamba env create -f donkeycar/install/envs/mac.yml \
    && conda activate donkey \
    && cd donkeycar \
    && pip install -e .[pc] \
    && pip install tensorflow==2.3.1 \
    && donkey createcar --path mynewcar/
