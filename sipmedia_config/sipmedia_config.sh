#!/bin/sh
rm /etc/network/interfaces
touch /etc/network/interfaces
cp /root/sipmedia_config/sipmedia_network_interfaces /etc/network/interfaces
ifdown eth0 && ifup eth0
apk update && apk upgrade

#install all dependencies
apk add freeswitch freeswitch-sounds-en-us-callie-8000 freeswitch-flite acf-freeswitch acf-freeswitch-vmail freeswitch-sample-config freeswitch-sounds-music-8000 ssmtp

#include the freeSWITCH files to lbu
lbu include var/lib/freeswitch
lbu include usr/sounds

#to get voicemail to work
mkdir /usr/storage
chown freeswitch:freeswitch /usr/storage
cp -avr /usr/share/freeswitch/sounds /usr/

mkdir /usr/conf
cp /etc/freeswitch/tetris.ttml /usr/conf

#Start FreesWITCH add it to rc-update:
/etc/init.d/freeswitch start && rc-update add freeswitch

apk update
apk cache sync
