#!/bin/bash

# Used to mount a sparsebundle to improve TimeMachine backups of a VMWare Fusion VM.
#
# See: http://www.markwheadon.com/blog/2009/06/backing-up-virtual-machine-using-sparse-bundle
# 
# Use sudo vifs to add a mount point for your Virtual Machines directory (or, live with /Volumes)
#
# UUID=F87FAA61-B92D-3B8D-BF0E-98127C9B1914 /Users/cleggett/Documents/Virtual\040Machines hfs rw 1 0

open ~/Documents/Virtual\ Machines.sparsebundle
