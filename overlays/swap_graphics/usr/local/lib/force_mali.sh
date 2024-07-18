#!/bin/sh

LIBDIR=$(dirname $(realpath $0))
DESDIR=/usr/lib/aarch64-linux-gnu

# Swap symbolic links

#-----------------------------------------------------
cd ${DESDIR}
#-----------------------------------------------------

ln -fs ${LIBDIR}/libEGL.so libEGL.so.1
ln -fs ${LIBDIR}/libgbm.so libgbm.so.1
ln -fs ${LIBDIR}/libGLESv1_CM.so libGLESv1_CM.so.1
ln -fs ${LIBDIR}/libGLESv2.so libGLESv2.so.2
ln -fs ${LIBDIR}/libOpenCL.so libOpenCL.so.2
ln -fs ${LIBDIR}/libwayland-egl.so libwayland-egl.so.1
ln -fs ${LIBDIR}/mali_wayland/libmali.so libmali.so

#-----------------------------------------------------
cd pkgconfig
#-----------------------------------------------------

ln -fs ${LIBDIR}/pkgconfig/egl.pc egl.pc
ln -fs ${LIBDIR}/pkgconfig/gbm.pc gbm.pc
ln -fs ${LIBDIR}/pkgconfig/glesv1.pc glesv1.pc
ln -fs ${LIBDIR}/pkgconfig/glesv1_cm.pc glesv1_cm.pc
ln -fs ${LIBDIR}/pkgconfig/glesv2.pc glesv2.pc
ln -fs ${LIBDIR}/pkgconfig/OpenCL.pc OpenCL.pc
ln -fs ${LIBDIR}/pkgconfig/wayland-egl.pc wayland-egl.pc

echo "Mali driver injected !!!"
