FROM nvidia/cudagl:11.3.0-devel-ubuntu20.04
SHELL ["/bin/bash", "-c"]
# Set the timezone info because otherwise tzinfo blocks install 
# flow and ignores the non-interactive frontend command 🤬🤬🤬
RUN ln -snf /usr/share/zoneinfo/America/New_York /etc/localtime && echo "/usr/share/zoneinfo/America/New_York" > /etc/timezone

# Core system packages
RUN apt update --fix-missing
RUN apt install -y software-properties-common wget curl gpg gcc git make apt-utils

# Install miniconda to /miniconda
RUN curl -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda/bin:${PATH}

# Install os-level packages
# From https://github.com/haosulab/ManiSkill2/blob/main/docker/Dockerfile#L6
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    bash-completion \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    htop \
    libegl1 \
    libxext6 \
    libjpeg-dev \
    libpng-dev  \
    libvulkan1 \
    rsync \
    tmux \
    unzip \
    vim \
    vulkan-utils \
    wget \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# From https://github.com/haosulab/ManiSkill2/blob/main/docker/Dockerfile#L40
COPY nvidia_icd.json /usr/share/vulkan/icd.d/nvidia_icd.json
COPY nvidia_layers.json /etc/vulkan/implicit_layer.d/nvidia_layers.json

# Set standard environment variables so any libraries with CUDA support build with CUDA 
# support for all the common NVidia architectures
ENV TORCH_CUDA_ARCH_LIST="Ampere;Turing;Pascal"
ENV FORCE_CUDA="1"
RUN conda update -y conda
RUN conda install numpy python=3.10 pytorch==1.11 torchvision torchaudio cudatoolkit=11.3 -c pytorch -y
RUN pip install open3d==0.16

RUN git clone https://github.com/haosulab/ManiSkill2.git /ManiSkill2
WORKDIR /ManiSkill2
RUN git checkout 5e0f0fee93ac2f6101e5c6cd050246eb7e3b06e9
RUN pip install -e .
RUN yes | python -m mani_skill2.utils.download_asset ycb
RUN yes | python -m mani_skill2.utils.download_asset minimal_bedroom
RUN yes | python -m mani_skill2.utils.download_demo PickSingleYCB-v0

RUN conda install -c fvcore -c iopath -c conda-forge fvcore iopath -y
RUN pip install --no-index --no-cache-dir pytorch3d -f https://dl.fbaipublicfiles.com/pytorch3d/packaging/wheels/py310_cu113_pyt1110/download.html
RUN pip install ninja


RUN git clone https://github.com/haosulab/ManiSkill2-Learn.git /ManiSkill2-Learn
WORKDIR /ManiSkill2-Learn
RUN git checkout fafbcafccf29f5e8dc99b2fd584ecbdfeaea22a4
# Delete the 18th line of the requirements.txt file because it has a bad version of gym
RUN sed -i '18d' requirements.txt
RUN pip install gymnasium
RUN conda install scikit-image==0.18.3 -y
RUN pip install -e . 
RUN pip install protobuf==3.19.0
RUN apt update
RUN apt install -y libsparsehash-dev
RUN pip install torchsparse@git+https://github.com/lz1oceani/torchsparse.git

RUN ln -s ../ManiSkill2/data data

# Add the project to the PYTHONPATH so that we can import modules from it
ENV PYTHONPATH=/project:/ManiSkill2-Learn:${PYTHONPATH}
# Add the modified bashrc to the container so we get a nice prompt and persistent history
COPY bashrc /root/.bashrc
# Set the working directory to the project directory, where we will mount the repo
WORKDIR /project