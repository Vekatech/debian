#!/bin/sh

# Auto login

if [ -f /etc/lightdm/lightdm.conf ]; then
    /usr/bin/sed -i "s|#xserver-command=X|xserver-command=X -s 0 -dpms|;s|#autologin-user=|autologin-user=$1|" /etc/lightdm/lightdm.conf
fi
