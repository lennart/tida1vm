#!/bin/bash

DIRT_IP=$(/sbin/ifconfig eth0 | sed -n "s/^.*inet addr:\(.*\)\s*Bcast.*$/\1/p")

export DIRT_IP



cd Dirt

ps aux | grep "jack"

sleep 2

jackd -P85 -d alsa &

sleep 2

./dirt > ./dirt.log 2>&1 &

echo "Dirt started on ${DIRT_IP}"

exec bash


