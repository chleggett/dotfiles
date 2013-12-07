#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage - $0 username hostname"
  exit 1
fi
  killall ssh
  killall synergyc
  ssh -f -N -L 24800:$2:24800 $1@$2
  /opt/local/bin/synergyc -f 127.0.0.1

