FROM ubuntu:focal as builder

ARG NVIM_TARGET_BRANCH=master \
    DEBIAN_FRONTEND=noninteractive

ARG BUILD_APT_DEPS="ninja-build \
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    cmake \
    g++ \
    pkg-config \
    unzip \
    git \
    binutils"

RUN apt update --fix-missing
RUN apt upgrade -y
RUN apt install -y ${BUILD_APT_DEPS}
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim
RUN cd /tmp/neovim && \
    git fetch --all --tags -f && \
    git checkout ${NVIM_TARGET_BRANCH} && \
    make CMAKE_BUILD_TYPE=Release && \
    make CMAKE_INSTALL_PREFIX=/usr/local install && \
    strip /usr/local/bin/nvim

RUN useradd -m \
  -d /home/username \
  -s /bin/bash \
  -g users \
  -G root \
  -u 1000 \
  username

USER username
WORKDIR /home/username
