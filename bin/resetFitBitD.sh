#!/usr/bin/env bash

sudo launchctl unload /Library/LaunchDaemons/com.fitbit.fitbitd.plist
sudo launchctl load /Library/LaunchDaemons/com.fitbit.fitbitd.plist
