#!/usr/bin/env bash

# To prevent conflicts, before running ensure that all instances
# of polybar are first stopped.

killall -q polybar
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done
polybar kalibar-vaporwave &
