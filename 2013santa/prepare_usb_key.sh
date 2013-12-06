#!/bin/sh

set -e

copy_key() {
    device="$1"
    statefile="state_$(basename $device)"
    if ! [ -e "$device" ] || [ -e "$statefile" ]; then
        return
    fi
    touch "$statefile"

    echo "copying iso to $device"
    sleep 5
    for i in 1 2 3 4; do
        if mount | grep -q "$device$i"; then
            umount "$device$i"
        fi
    done

    cp 2013santa.iso "$device"

    echo "done copying to $device. Please remove it."

    while [ -e "$device" ]; do
        sleep 1
    done

    rm $statefile
}

main() {

    while true; do
        for device in /dev/sdf /dev/sdg /dev/sdh /dev/sdi; do
            copy_key $device &
        done

        sleep 3
    done
}

main
