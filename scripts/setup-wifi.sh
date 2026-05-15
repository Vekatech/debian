#!/bin/sh

# Create symbolic links

/usr/bin/update-alternatives --install /lib/firmware/regulatory.db regulatory.db /lib/firmware/regulatory.db-$1 150 --slave /lib/firmware/regulatory.db.p7s regulatory.db.p7s /lib/firmware/regulatory.db.p7s-$1
