#!/bin/sh

growpart /dev/mmcblk0 2
#e2fsck -f /dev/mmcblk0p2
resize2fs /dev/mmcblk0p2
