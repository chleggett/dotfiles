#!/bin/bash

sudo argus -P 561 -d
sudo rasplit -M time 5m -n -S localhost -w "/var/log/argus/%Y/%m/%d/argus_%H:%M:%S" -d
