#!/bin/sh

USER=$1
if [ -z "$USER" ]; then
  USER=user
fi

PASS=$2
if [ -z "$PASS" ]; then
  PASS=$USER
fi

SUDO=$3
if [ "$SUDO" = "-n" ]; then
  SUDO="-n"
else
  SUDO="-y"
fi

adduser \
  --gecos "$USER" \
  --disabled-password \
  --shell /bin/bash \
  "$USER"

echo "$USER:$PASS" | chpasswd

if [ -d /etc/sudoers.d ] && [ "$SUDO" = "-y" ]; then
  adduser "$USER" sudo
  echo "$USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USER
fi
