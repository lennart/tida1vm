#!/bin/bash

echo "Daumenkino Client"
DAUMENKINO_IP=$(getent hosts server | awk '{ print $1 }')

export DAUMENKINO_IP
echo "[client] server ip: ${DAUMENKINO_IP}"
cd Daumenkino
cabal install

exec emacs
