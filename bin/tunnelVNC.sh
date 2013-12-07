#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage - $0 username hostname"
  exit 1
fi
  ssh -f -N -L 5900:$2:5900 $1@$2

