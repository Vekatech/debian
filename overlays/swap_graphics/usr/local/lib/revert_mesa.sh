#!/bin/sh


DESDIR=/usr/lib/aarch64-linux-gnu

# Swap symbolic links

#-----------------------------------------------------
cd ${DESDIR}
#-----------------------------------------------------

if [ -e "_libEGL.so.1" ]; then
    cp -a "_libEGL.so.1" "libEGL.so.1"
fi

if [ -e "_libgbm.so.1" ]; then
    cp -a "_libgbm.so.1" "libgbm.so.1"
fi

if [ -e "_libGLESv1_CM.so.1" ]; then
    cp -a "_libGLESv1_CM.so.1" "libGLESv1_CM.so.1"
fi

if [ -e "_libGLESv2.so.2" ]; then
    cp -a "_libGLESv2.so.2" "libGLESv2.so.2"
fi

if [ -e "_libOpenCL.so.2" ]; then
    cp -a "_libOpenCL.so.2" "libOpenCL.so.2"
fi

if [ -e "_libwayland-egl.so.1" ]; then
    cp -a "_libwayland-egl.so.1" "libwayland-egl.so.1"
fi

if [ -e "_libmali.so" ]; then
    cp -a "_libmali.so" "libmali.so."
fi

#-----------------------------------------------------
cd pkgconfig
#-----------------------------------------------------

if [ -e "_egl.pc" ]; then
    cp -a "_egl.pc" "egl.pc"
fi

if [ -e "_gbm.pc" ]; then
    cp -a "_gbm.pc" "gbm.pc"
fi

if [ -e "_glesv1.pc" ]; then
    cp -a "_glesv1.pc" "glesv1.pc"
fi

if [ -e "_glesv1_cm.pc" ]; then
    cp -a "_glesv1_cm.pc" "glesv1_cm.pc"
fi

if [ -e "_glesv2.pc" ]; then
    cp -a "_glesv2.pc" "glesv2.pc"
fi

if [ -e "_OpenCL.pc" ]; then
    cp -a "_OpenCL.pc" "OpenCL.pc"
fi

if [ -e "_wayland-egl.pc" ]; then
    cp -a "_wayland-egl.pc" "wayland-egl.pc"
fi

echo "Mesa driver reverted !!!"
