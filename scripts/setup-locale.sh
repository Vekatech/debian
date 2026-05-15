#!/bin/sh

locale=$1
if [ -z "$locale" ]; then
  locale=en_US
fi

cat > /etc/locale.gen <<EOF
en_US.UTF-8 UTF-8
en_GB.UTF-8 UTF-8
EOF

locale-gen
update-locale LANG=${locale}.UTF-8
