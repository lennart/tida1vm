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
RUN cabal update \
    && cabal install tidal-0.8 \
    && cabal install tidal-midi-0.8

###
#
# COPY default configs
#
###
ONBUILD COPY ["config/.bashrc", "$HOME/.bashrc"]
ONBUILD COPY ["config/.bash_profile", "$HOME/.bash_profile"]
ONBUILD COPY ["config/.motd", "$HOME/.motd"]
ONBUILD COPY ["config/.tmux.conf", "$HOME/.tmux.conf"]
ONBUILD COPY ["config/.emacs", "$HOME/.emacs"]
ONBUILD COPY ["config/tidal.el", "$HOME/.elisp/tidal.el"]
ONBUILD COPY ["tidal/init.tidal", "$HOME/livecode/init.tidal"]

ONBUILD RUN chown -Rh $USER:$USER -- $HOME

###
#
# Init
#
###
USER $USER
WORKDIR $HOME
