ARG UBUNTU_VERSION=jammy

FROM mcr.microsoft.com/devcontainers/base:${UBUNTU_VERSION}

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Some base packages
RUN apt update && apt install -y \
    python3-pip \
    python3-venv \
    python3-dev \
    build-essential \
    gfortran \
    git \
    curl \
    wget \
    unzip \
    lsb-release \
    wget \
    software-properties-common \
    gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# R
RUN apt update && apt install -y \
    r-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install Miniforge
ENV MINIFORGE_VERSION=latest
ENV MINIFORGE_INSTALL_DIR=/opt/miniforge
RUN wget -O /tmp/miniforge.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
    && bash /tmp/miniforge.sh -b -p $MINIFORGE_INSTALL_DIR \
    && rm /tmp/miniforge.sh
ENV PATH="$MINIFORGE_INSTALL_DIR/bin:$PATH"

# Install packages
RUN conda install -y \
    python=3.12 \
    numpy \
    scipy \
    matplotlib \
    pandas \
    ipykernel \
    pytorch \
    loky \
    && conda clean -afy

# Python package build tools
RUN pip install --no-input build wheel

# LLVM
ARG LLVM_VERSION=16
ENV LLVM_VERSION=${LLVM_VERSION}
RUN wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh $LLVM_VERSION \
    && apt install -y flang-$LLVM_VERSION \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Deps for Enzyme
RUN apt update \
    && apt install -y sudo git ssh zlib1g-dev libzstd-dev automake autoconf cmake make lldb ninja-build gcc g++ gfortran build-essential libtool llvm-$LLVM_VERSION-dev clang-format clangd clang-$LLVM_VERSION lld-$LLVM_VERSION libclang-$LLVM_VERSION-dev libomp-$LLVM_VERSION-dev libblas-dev libeigen3-dev libboost-dev python3 python3-pip \
    && python3 -m pip install lit pathlib2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Build Enzyme
RUN git clone https://github.com/EnzymeAD/Enzyme /opt/Enzyme \
    && cd /opt/Enzyme/enzyme \
    && git fetch --tags \
#    && git checkout tags/v0.0.172 \
    && mkdir build \
    && cd build \
    && cmake -G Ninja .. -DLLVM_DIR=/usr/lib/llvm-$LLVM_VERSION/lib/cmake/llvm/ -DLLVM_EXTERNAL_LIT=$(which lit) \
    && ninja
