#!/bin/bash --

ifdown p1p1
ifdown p1p2
ifdown p2p1
ifdown p2p2
modprobe -r igb
modprobe igb
ifup p1p1
ifup p1p2
ifup p2p1
ifup p2p2
ifconfig p1p1
ifconfig p1p2
ifconfig p2p1
ifconfig p2p2
