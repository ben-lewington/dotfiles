ARG BASE_IMAGE=ubuntu:focal
ARG NON_ROOT_USER=username

FROM $BASE_IMAGE as builder

ARG BUILD_APT_DEPS="ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git binutils"
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGET=master

RUN apt update && apt upgrade -y && \
  apt install -y ${BUILD_APT_DEPS} && \
  git clone https://github.com/neovim/neovim.git /tmp/neovim && \
  cd /tmp/neovim && \
  git fetch --all --tags -f && \
  git checkout ${TARGET} && \
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

COPY --chown=username:users ./src/ /home/username/

USER username
WORKDIR /home/username
