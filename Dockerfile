FROM 90c202b23b00

RUN apt-get update && \
    apt-get install -yq \
    xorg-dev x-window-system \
    libglfw3-dev \
    binutils mesa-utils module-init-tools git-core

# proprietary stuff
ADD nvidia-driver.run /tmp/nvidia-driver.run
RUN sh /tmp/nvidia-driver.run -a -N --ui=none --no-kernel-module && \
    rm /tmp/nvidia-driver.run

# install dependencies, remove possible stale git-version afterwards
RUN git clone https://github.com/lennart/Daumenkino && \
    cd $HOME/Daumenkino && \
    cabal install && \
    rm -Rf $HOME/Daumenkino
    
# RUN apt-get install -yq sudo

# RUN export uid=1000 gid=1000 && \
#     echo "tidal:x:${uid}:${gid}:Tidal,,,:/home/tidal:/bin/bash" >> /etc/passwd && \
#     echo "tidal:x:${uid}:" >> /etc/group && \
#     echo "tidal ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/tidal && \
#     chown ${uid}:${gid} -R /home/tidal
    
# USER tidal
