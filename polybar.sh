#!/usr/bin/env sh

killall -q -s SIGKILL polypar

while pgrep -x polybar >/dev/null; do sleep 1; done

polybar bottom &
