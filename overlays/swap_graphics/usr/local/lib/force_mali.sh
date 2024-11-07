#!/bin/sh

LIBDIR=$(dirname $(realpath $0))
DESDIR=/usr/lib/aarch64-linux-gnu

# Swap symbolic links

#-----------------------------------------------------
cd ${DESDIR}
#-----------------------------------------------------

if [ -f ${LIBDIR}/libEGL.so ]; then
    ln -fs ${LIBDIR}/libEGL.so libEGL.so.1
fi
if [ -f ${LIBDIR}/libgbm.so ]; then
    ln -fs ${LIBDIR}/libgbm.so libgbm.so.1
fi
if [ -f ${LIBDIR}/libGLESv1_CM.so ]; then
    ln -fs ${LIBDIR}/libGLESv1_CM.so libGLESv1_CM.so.1
fi
if [ -f ${LIBDIR}/libGLESv2.so ]; then
    ln -fs ${LIBDIR}/libGLESv2.so libGLESv2.so.2
fi
if [ -f ${LIBDIR}/libOpenCL.so ]; then
    ln -fs ${LIBDIR}/libOpenCL.so libOpenCL.so.2
fi
if [ -f ${LIBDIR}/libwayland-egl.so ]; then
    ln -fs ${LIBDIR}/libwayland-egl.so libwayland-egl.so.1
fi
if [ -f ${LIBDIR}/mali_wayland/libmali.so ]; then
    ln -fs ${LIBDIR}/mali_wayland/libmali.so libmali.so
fi

#-----------------------------------------------------
cd pkgconfig
#-----------------------------------------------------

if [ -f ${LIBDIR}/pkgconfig/egl.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/egl.pc egl.pc
fi
if [ -f ${LIBDIR}/pkgconfig/gbm.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/gbm.pc gbm.pc
fi
if [ -f ${LIBDIR}/pkgconfig/glesv1.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/glesv1.pc glesv1.pc
fi
if [ -f ${LIBDIR}/pkgconfig/glesv1_cm.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/glesv1_cm.pc glesv1_cm.pc
fi
if [ -f ${LIBDIR}/pkgconfig/glesv2.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/glesv2.pc glesv2.pc
fi
if [ -f ${LIBDIR}/pkgconfig/OpenCL.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/OpenCL.pc OpenCL.pc
fi
if [ -f ${LIBDIR}/pkgconfig/wayland-egl.pc ]; then
    ln -fs ${LIBDIR}/pkgconfig/wayland-egl.pc wayland-egl.pc
fi

echo "Mali driver injected !!!"
