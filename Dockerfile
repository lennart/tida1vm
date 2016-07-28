FROM debian:jessie
MAINTAINER Lennart <lennart@melzer.it>

###
#
# Define ENV_VARS
#
###
ENV LANG C.UTF-8
ENV USER root

ENV HOME /home/tidal
ENV PATH $PATH:$HOME/bin

ENV DEBIAN_FRONTEND noninteractive

####
#
# Add backports.
# `ghc` is kinda old in Jessie, luckily someone backported it.
#
##
COPY ["config/etc/apt/sources.list.d/backports.list", "/etc/apt/sources.list.d/backports.list"]

RUN echo \
   'deb ftp://ftp.us.debian.org/debian/ jessie main\n \
    deb ftp://ftp.us.debian.org/debian/ jessie-updates main\n \
    deb http://security.debian.org jessie/updates main\n' \
    > /etc/apt/sources.list

###
#
# Install dependencies &&
# Create home and user dirs
#
###
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq \
    binutils \
    curl \
    cabal-install \
    ca-certificates \
    emacs24-nox \
    git-core \
    haskell-mode \
    liblo7 \
    libportmidi0 \
    libportmidi-dev
    libasound2-dev \
    libglfw3-dev \
    mesa-utils \
    module-init-tools \
    tmux \
    unzip \
    xorg-dev \
    x-window-system \
    zlib1g-dev \
    --no-install-recommends \
    && apt-get install -yt jessie-backports ghc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $HOME \
    && mkdir -p $HOME/.elisp \
    && mkdir -p $HOME/livecode

###
#
# Install Tidal && Fix perms
#
###
# proprietary stuff

ENV NVIDIA_VERSION 304.131

RUN curl -L http://us.download.nvidia.com/XFree86/Linux-x86_64/{$NVIDIA_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_VERSION}.run \
    > /tmp/nvidia-driver.run
  # wget -O nvidia-driver.run $nvidia_driver_uri

# ADD nvidia-driver.run /tmp/nvidia-driver.run
RUN sh /tmp/nvidia-driver.run -a -N --ui=none --no-kernel-module && \
    rm /tmp/nvidia-driver.run

# install dependencies, remove possible stale git-version afterwards
RUN cd $HOME && git clone https://github.com/lennart/Daumenkino && \
    cd $HOME/Daumenkino && \
    cabal update \
    && cabal install && \
    rm -Rf $HOME/Daumenkino
    
###
#
# COPY default configs
#
###
RUN chown -Rh $USER:$USER -- $HOME

###
#
# Init
#
###
USER $USER
WORKDIR /home/tidal
EXPOSE 23451/udp

COPY ["config/.bashrc", "$HOME/.bashrc"]
COPY ["config/.bash_profile", "$HOME/.bash_profile"]
COPY ["config/.motd", "$HOME/.motd"]
COPY ["config/.tmux.conf", "$HOME/.tmux.conf"]
COPY ["config/.emacs", "$HOME/.emacs"]
COPY ["config/tidal.el", "$HOME/.elisp/tidal.el"]
COPY ["tidal/init.tidal", "tidal/helpers.tidal", "$HOME/livecode/"]
COPY ["helpers/server.sh", "helpers/client.sh", "$HOME/"]


