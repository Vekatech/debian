#!/bin/sh

LIBDIR=/usr/local/lib
DESDIR=/usr/lib/aarch64-linux-gnu

# Create symbolic links

#-----------------------------------------------------
cd ${DESDIR}
#-----------------------------------------------------

if [ -e "libEGL.so.1" ]; then
    mv "libEGL.so.1" "_libEGL.so.1"
fi
ln -fs ${LIBDIR}/libEGL.so libEGL.so.1

if [ -e "libgbm.so.1" ]; then
    mv "libgbm.so.1" "_libgbm.so.1"
fi
ln -fs ${LIBDIR}/libgbm.so libgbm.so.1

if [ -e "libGLESv1_CM.so.1" ]; then
    mv "libGLESv1_CM.so.1" "_libGLESv1_CM.so.1"
fi
ln -fs ${LIBDIR}/libGLESv1_CM.so libGLESv1_CM.so.1

if [ -e "libGLESv2.so.2" ]; then
    mv "libGLESv2.so.2" "_libGLESv2.so.2"
fi
ln -fs ${LIBDIR}/libGLESv2.so libGLESv2.so.2

if [ -e "libOpenCL.so.2" ]; then
    mv "libOpenCL.so.2" "_libOpenCL.so.2"
fi
ln -fs ${LIBDIR}/libOpenCL.so libOpenCL.so.2

if [ -e "libwayland-egl.so.1" ]; then
    mv "libwayland-egl.so.1" "_libwayland-egl.so.1"
fi
ln -fs ${LIBDIR}/libwayland-egl.so libwayland-egl.so.1

if [ -e "libmali.so" ]; then
    mv "libmali.so" "_libmali.so."
fi
ln -fs ${LIBDIR}/mali_wayland/libmali.so libmali.so

#-----------------------------------------------------
cd pkgconfig
#-----------------------------------------------------

if [ -e "egl.pc" ]; then
    mv "egl.pc" "_egl.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/egl.pc egl.pc

if [ -e "gbm.pc" ]; then
    mv "gbm.pc" "_gbm.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/gbm.pc gbm.pc

if [ -e "glesv1.pc" ]; then
    mv "glesv1.pc" "_glesv1.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/glesv1.pc glesv1.pc

if [ -e "glesv1_cm.pc" ]; then
    mv "glesv1_cm.pc" "_glesv1_cm.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/glesv1_cm.pc glesv1_cm.pc

if [ -e "glesv2.pc" ]; then
    mv "glesv2.pc" "_glesv2.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/glesv2.pc glesv2.pc

if [ -e "OpenCL.pc" ]; then
    mv "OpenCL.pc" "_OpenCL.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/OpenCL.pc OpenCL.pc

if [ -e "wayland-egl.pc" ]; then
    mv "wayland-egl.pc" "_wayland-egl.pc"
fi
ln -fs ${LIBDIR}/pkgconfig/wayland-egl.pc wayland-egl.pc
