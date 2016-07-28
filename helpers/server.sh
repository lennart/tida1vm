#!/bin/bash

echo "Daumenkino Server"
cd Daumenkino
CURRENT_IP=$(ip add show eth0 | sed -n 's/\s*inet \([^\/]*\).*/\1/p')


if [ "$DEBUG" = "1" ]; then
    xterm
else
    cabal configure \
        && DAUMENKINO_IP=$CURRENT_IP cabal run Daumenkino
fi


