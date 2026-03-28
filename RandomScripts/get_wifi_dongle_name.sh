#!/bin/bash
# www.theutsguy.com
# fipi@theutsguy.com
# This is a random thing I made, don't use it for anything.
# Don't listen to anything I say or do anything I do.
# 
# This script gets the name of your USB Wi-Fi adapter and tells Kismet to use it as a data source.
# You cannot reliably use the onboard Wi-Fi on the Raspberry Pi in monitor mode so you need a USB Wi-Fi Adapter.
# USB Wi-Fi Adapters get different interface names all the time so I didn't want to have to edit the kismet.conf file every time I put in a new Wi-Fi dongle.
# Since cannot just assign an index to the Wi-Fi adapter like you can the Zigbee or RTL-SDR dongles so you need this script. 
# You must ensure all adapters are plugged in BEFORE you power on the Raspberry Pi.
# I suggest having this script run in your sudo crontab @reboot
# This assumes the location of kismet.conf is /etc/kismet/kismet.conf, modify it accordingly if you have yours in a different location.

found=0

while read -r iface; do
    if readlink -f "/sys/class/net/$iface/device" | grep -q usb; then
        sed -i "1c\source=$iface" /etc/kismet/kismet.conf
        ip link set $iface up
        found=1
        break
    fi
done < <(iw dev | awk '$1=="Interface"{print $2}')

if [ "$found" -eq 0 ]; then
    sed -i "1c\#No USB Wi-Fi Adapter Found" /etc/kismet/kismet.conf
fi


exit 0
