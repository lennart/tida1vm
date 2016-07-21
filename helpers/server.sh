#!/bin/sh

cd Daumenkino

cabal configure && DAUMENKINO_IP=$(ip add show eth0 | sed -n 's/\s*inet \([^\/]*\).*/\1/p') cabal run Daumenkino
