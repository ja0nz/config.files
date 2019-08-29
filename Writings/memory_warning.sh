#!/usr/bin/env bash
# Copyright 2019, Mikko Rantalainen
# License: MIT X License

## Stress test in fish shell
# stress --vm-bytes (awk '/MemAvailable/{printf "%d\n", $2 * 0.98;}' < /proc/meminfo)k --vm-keep -m 1

# Minimum available memory until warning, default to 10% of total RAM (MiB)
THRESHOLD=$(grep "MemTotal:" /proc/meminfo | awk '{ printf "%d", 0.1*$2/1024}')
INTERVAL=60s

echo "Emitting a warning if less than $THRESHOLD MiB of RAM is available..."

while true; do
    meminfo=$(cat /proc/meminfo)
    free=$(echo "$meminfo" | grep "MemFree:" | awk '{ printf "%d", $2/1024}')
    available=$(echo "$meminfo" | grep "MemAvailable:" | awk '{ printf "%d", $2/1024}')
    inactive=$(echo "$meminfo" | grep "Inactive:" | awk '{ printf "%d", $2/1024}')
    reclaimable=$(echo "$meminfo" | grep "SReclaimable:" | awk '{ printf "%d", $2/1024}')
    usable=$(echo "$free + $inactive / 2 + $reclaimable / 2" | bc)
    if test -z "$available"; then
        message="Current kernel does not support MemAvailable in /proc/meminfo, aborting"
        notify-send "Error while monitoring low memory" "$message"
        echo "$message" 1>&2
        exit 1
    fi

    message="Available: $available MiB
        Free: $free MiB
        Maybe usable: $usable MiB"

    if [ "$available" -lt "$THRESHOLD" ]
    then
        notify-send -u critical "Low memory warning" "$message"
        echo "Low memory warning:"
        echo "$message"
    fi

    #echo "DEBUG: $message"
    sleep $INTERVAL
done