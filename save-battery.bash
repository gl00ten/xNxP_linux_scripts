#!/usr/bin/env bash

sudo powertop --auto-tune
sudo cpupower frequency-set -g powersave
