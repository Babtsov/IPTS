#!/bin/sh
/etc/init.d/networking start
rc-update add networking
ping www.google.com
