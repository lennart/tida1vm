FROM mitchty/alpine-ghc:latest

ENV HOME /home/tidal

RUN mkdir -p $HOME

RUN apk --update add \
    autoconf libtool automake \
    bash \
    gcc g++ make \
    git \
    zlib \
    alsa-lib-dev \
    libsamplerate-dev \
    libsndfile-dev \
    python

RUN git clone git://liblo.git.sourceforge.net/gitroot/liblo/liblo $HOME/liblo \
    && cd $HOME/liblo \
    && sed -i "s/^#include <sys\/poll.h>\s*$/#include <poll.h>/" ./src/server.c \
    && sh ./autogen.sh \
    && make \
    && make install

RUN git clone git://github.com/jackaudio/jack2 --depth 1 $HOME/jack2 \
    && cd $HOME/jack2 \
    && ./waf configure --alsa \
    && ./waf build \
    && ./waf install

# RUN echo "@audio - memlock 256000\n@audio - rtprio 75" >> /etc/security/limits.conf

RUN git clone https://github.com/tidalcycles/Dirt $HOME/Dirt \
    && cd $HOME/Dirt \
    && make clean \
    && make

RUN git clone --branch 0.9-dev https://github.com/tidalcycles/Tidal $HOME/Tidal

###
RUN cd $HOME/Tidal \
    && cabal update && cabal install

RUN apk --update add \
    linux-pam \
    && addgroup root audio \
    && echo "@audio - memlock 256000" >> /etc/security/limits.conf \
    && echo "@audio - rtprio 75" >> /etc/security/limits.conf

RUN cd $HOME/Dirt \
    && git submodule update --init

COPY dirt.sh $HOME/dirt.sh
RUN chmod +x $HOME/dirt.sh

WORKDIR $HOME
ENTRYPOINT ./dirt.sh
