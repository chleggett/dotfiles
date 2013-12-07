#!/bin/bash

brew uninstall $1
brew uninstall $(join <(brew leaves) <(brew deps $1))
