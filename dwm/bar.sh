#!/usr/bin/env bash
wmname LG3D
sleep 0.1
picom -b --experimental-backend
sleep 2
while true
do
    xsetroot -name "MEM $(free -g | grep Mem | cut -d " " --fields=15,25,24,26 | awk '{ printf "%d/%d GB", $2+$3+$4, $1 }')  $(uname -r) $(date +%D) $(date +%H:%M)";
    sleep 30s;
done
