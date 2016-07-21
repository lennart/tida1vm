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

###
#
# Install dependencies &&
# Create home and user dirs
#
###
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -yq \
    emacs24-nox haskell-mode tmux \
    zlib1g-dev liblo7 libportmidi0 \
    libportmidi-dev libasound2-dev \
    cabal-install wget unzip \
    ca-certificates \
    xorg-dev x-window-system \
    libglfw3-dev \
    binutils mesa-utils module-init-tools git-core \
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
ADD nvidia-driver.run /tmp/nvidia-driver.run
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

COPY helpers/server.sh server.sh
COPY ["config/.bashrc", "$HOME/.bashrc"]
COPY ["config/.bash_profile", "$HOME/.bash_profile"]
COPY ["config/.motd", "$HOME/.motd"]
COPY ["config/.tmux.conf", "$HOME/.tmux.conf"]
COPY ["config/.emacs", "$HOME/.emacs"]
COPY ["config/tidal.el", "$HOME/.elisp/tidal.el"]
COPY ["tidal/init.tidal", "$HOME/livecode/init.tidal"]
COPY ["tidal/helpers.tidal", "$HOME/livecode/helpers.tidal"]
