#!/bin/bash

if [ $# -ne 3 ]
then
  echo "Usage - $0 username hostname port"
  exit 1
fi
  ssh -f -N -L $3:$2:$3 $1@$2

