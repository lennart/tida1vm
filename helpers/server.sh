#!/bin/bash

echo "Daumenkino Server"
cd Daumenkino
CURRENT_IP=$(ip add show eth0 | sed -n 's/\s*inet \([^\/]*\).*/\1/p')

if [ -z "$DEBUG" ]; then
    echo "NORMAL STARTUP"
cabal configure \
    && DAUMENKINO_IP=$CURRENT_IP cabal run Daumenkino
else
    echo "Starting XTERM, debug-mode"
    xterm
fi

