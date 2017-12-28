#!/usr/bin/env sh

killall -q polypar

while pgrep -x polybar >/dev/null; do sleep 1; done

polybar bottom &
