FROM tensorflow/tensorflow:2.3.1-gpu

ARG USERNAME
ARG USER_UID
ARG USER_GID

WORKDIR /home/donkeycar

RUN rm /etc/apt/sources.list.d/cuda.list \
    && rm /etc/apt/sources.list.d/nvidia-ml.list

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN sudo apt-get install -y wget --no-install-recommends g++ gcc ca-certificates\
    && sudo apt-get install -y git \
    && sudo apt-get install -y libgl1-mesa-glx

RUN git clone https://github.com/autorope/donkeycar.git \
    && cd donkeycar \
    && git checkout 2c4f3e4

RUN pip install --upgrade pip \
    && cd donkeycar \
    && pip install opencv-python==4.5.3.56  \
    && pip install -e .[pc]

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
