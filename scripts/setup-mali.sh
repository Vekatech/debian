#!/bin/sh

LIBDIR=/usr/local/lib
DESDIR=/usr/lib/aarch64-linux-gnu

# Create symbolic links

#-----------------------------------------------------
cd ${DESDIR}
#-----------------------------------------------------

if [ -f ${LIBDIR}/libEGL.so ]; then
    if [ -e "libEGL.so.1" ]; then
        mv "libEGL.so.1" "_libEGL.so.1"
    fi
    ln -fs ${LIBDIR}/libEGL.so libEGL.so.1
fi

if [ -f ${LIBDIR}/libgbm.so ]; then
    if [ -e "libgbm.so.1" ]; then
        mv "libgbm.so.1" "_libgbm.so.1"
    fi
    ln -fs ${LIBDIR}/libgbm.so libgbm.so.1
fi

if [ -f ${LIBDIR}/libGLESv1_CM.so ]; then
    if [ -e "libGLESv1_CM.so.1" ]; then
        mv "libGLESv1_CM.so.1" "_libGLESv1_CM.so.1"
    fi
    ln -fs ${LIBDIR}/libGLESv1_CM.so libGLESv1_CM.so.1
fi

if [ -f ${LIBDIR}/libGLESv2.so ]; then
    if [ -e "libGLESv2.so.2" ]; then
        mv "libGLESv2.so.2" "_libGLESv2.so.2"
    fi
    ln -fs ${LIBDIR}/libGLESv2.so libGLESv2.so.2
fi

if [ -f ${LIBDIR}/libOpenCL.so ]; then
    if [ -e "libOpenCL.so.2" ]; then
        mv "libOpenCL.so.2" "_libOpenCL.so.2"
    fi
    ln -fs ${LIBDIR}/libOpenCL.so libOpenCL.so.2
fi

if [ -f ${LIBDIR}/libwayland-egl.so ]; then
    if [ -e "libwayland-egl.so.1" ]; then
        mv "libwayland-egl.so.1" "_libwayland-egl.so.1"
    fi
    ln -fs ${LIBDIR}/libwayland-egl.so libwayland-egl.so.1
fi

if [ -f ${LIBDIR}/mali_wayland/libmali.so ]; then
    if [ -e "libmali.so" ]; then
        mv "libmali.so" "_libmali.so."
    fi
    ln -fs ${LIBDIR}/mali_wayland/libmali.so libmali.so
fi

#-----------------------------------------------------
cd pkgconfig
#-----------------------------------------------------

if [ -f ${LIBDIR}/pkgconfig/egl.pc ]; then
    if [ -e "egl.pc" ]; then
        mv "egl.pc" "_egl.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/egl.pc egl.pc
fi

if [ -f ${LIBDIR}/pkgconfig/gbm.pc ]; then
    if [ -e "gbm.pc" ]; then
        mv "gbm.pc" "_gbm.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/gbm.pc gbm.pc
fi

if [ -f ${LIBDIR}/pkgconfig/glesv1.pc ]; then
    if [ -e "glesv1.pc" ]; then
        mv "glesv1.pc" "_glesv1.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/glesv1.pc glesv1.pc
fi

if [ -f ${LIBDIR}/pkgconfig/glesv1_cm.pc ]; then
    if [ -e "glesv1_cm.pc" ]; then
        mv "glesv1_cm.pc" "_glesv1_cm.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/glesv1_cm.pc glesv1_cm.pc
fi

if [ -f ${LIBDIR}/pkgconfig/glesv2.pc  ]; then
    if [ -e "glesv2.pc" ]; then
        mv "glesv2.pc" "_glesv2.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/glesv2.pc glesv2.pc
fi

if [ -f ${LIBDIR}/pkgconfig/OpenCL.pc ]; then
    if [ -e "OpenCL.pc" ]; then
        mv "OpenCL.pc" "_OpenCL.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/OpenCL.pc OpenCL.pc
fi

if [ -f ${LIBDIR}/pkgconfig/wayland-egl.pc ]; then
    if [ -e "wayland-egl.pc" ]; then
        mv "wayland-egl.pc" "_wayland-egl.pc"
    fi
    ln -fs ${LIBDIR}/pkgconfig/wayland-egl.pc wayland-egl.pc
fi

