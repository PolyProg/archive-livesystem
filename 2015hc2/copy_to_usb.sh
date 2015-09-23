#!/bin/sh

set -e

[ $# -eq 2 ] || { echo "usage: $0 image drive" >&2; exit 1; }

image=$1
drive=$2

[ -f "$image" ] || { echo "Could not find image: $image" >&2; exit 1; }

while true; do
    echo "Waiting for $drive"
    while ! [ -b "$drive" ]; do
        sleep 1
    done

    echo "Unmounting"
    for partition in "$drive"*; do
        umount "$partition" >/dev/null 2>&1  || true
    done

    echo "Copying..."
    beep -r 1
    cp "$image" "$drive"
    sync

    echo "Waiting for device to be removed"
    beep -r 3
    while [ -b "$drive" ]; do
        sleep 1
    done
done
