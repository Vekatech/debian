#!/bin/bash

R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
#B='\033[0;34m'
M='\033[0;35m'
GRAY='\033[0;90m'
E='\033[0m'

if [ $# -ne 1 ]; then
    echo "Usage: $0 <RECIPE.yaml>"
    exit 1
else
    BRD=${1%_*} 
    echo -e "\nBuilding ${M}Debian${E} for ${G}${BRD}${E} board\n"
fi

case "${BRD}" in
    "vkrzv2l" | "vkcmv2l")
        FML="v2l"
    ;;
    "vkrzg2l" | "vkrzg2lc" | "vkrzg2ul" | "vkcmg2l" | "vkcmg2lc" | "vk-d184280e" | "vk-d184280e-kd070" | "vk-d184280e-kd070_1" | "vk-d184280e-kd101")
        FML="g2l"
    ;;
    *)
        echo -e "Unsupported <${R}BOARD${E}>_debian.yaml: ${R}$1${E}"
        echo -e "Available BOARDs are: ${G}vkrzv2l${E} | ${G}vkrzg2l${E} | ${G}vkrzg2lc${E} | ${G}vkrzg2ul${E} | | ${G}vkcmv2l${E} | ${G}vkcmg2l${E} | ${G}vkcmg2lc${E} | ${G}vk-d184280e${E} | ${G}vk-d184280e-kd070${E} | ${G}vk-d184280e-kd070_1${E} | ${G}vk-d184280e-kd101${E}"
        exit 1 
    ;;
esac

SRC=$(dirname $(realpath $0))
KERNEL_PATH=${SRC}/kernel
CACHE_PATH=${SRC}/overlays/boards
#YOCTO_PATH=
YOCTO_PATH=
#YOCTO_PATH=${SRC}/../yocto/vlp_v3.0.6/yocto/v3.0.6-${FML:0:1}2l/${BRD}/tmp/deploy/images
#YOCTO_PATH=${SRC}/../yocto/vlp_v3.0.6/yocto-kiosk/v3.0.6-${FML:0:1}2l/${BRD}/tmp/deploy/images

APP_PATH=${SRC}/webpanel
SIGN_PATH=/home/${USER}/Documents/LV/src/flasher/image
KERNEL=

cleanup_mount() {
    sudo umount "/mnt" 2>/dev/null || true

    if [ -n "${DEV:-}" ]; then
        sudo losetup -d "${DEV}" 2>/dev/null || true
    fi
}

trap cleanup_mount EXIT

echo -e "Checking for ${Y}kernel${E} img ..."
if [ -d ${CACHE_PATH}/${BRD} ]; then
    echo -e "  Looking in ${G}CACHE${E} folder ... "
    IMG="Image"
    if [ -e ${CACHE_PATH}/${BRD}/boot/${IMG} ]; then
        echo -e "    Found ${G}${IMG}${E} ... $(realpath ${CACHE_PATH}/${BRD})/boot${GRAY}/${IMG}${E}"
        KERNEL=${CACHE_PATH}/${BRD}/boot/${IMG}
    else
        echo -e "    No ${R}${IMG}${E} found ... $(realpath ${CACHE_PATH}/${BRD})/boot"
    fi
else
    echo -e "  Looking in ${G}CACHE${E} folder ... No ${R}${BRD}${E} folder"
fi

if [ -z "${KERNEL}" ]; then
    if [ -d "${YOCTO_PATH}/${BRD}" ]; then
        echo -e "  Looking in ${G}YOCTO${E} folder ..."
        IMG=$(find "${YOCTO_PATH}/${BRD}" -type l -name "*-${BRD}.wic" -exec basename {} \;)
        case "${IMG}" in
            "core-image-minimal-${BRD}.wic" | "core-image-bsp-${BRD}.wic" | "core-image-weston-${BRD}.wic" | "core-image-qt-${BRD}.wic" )
                echo -e "    Found ${G}${IMG}${E} ... $(realpath ${YOCTO_PATH}/${BRD})${GRAY}/${IMG}${E}"
                KERNEL=$(realpath ${YOCTO_PATH}/${BRD})/${IMG}
            ;;
            *)
                echo -e "    ${R}No img found${E} ... $(realpath ${YOCTO_PATH}/${BRD})"
            ;;
        esac
    else    
        echo -e "  Looking in ${G}YOCTO${E} folder ... No ${R}yocto${E} folder"
    fi
fi

if [ -z "${KERNEL}" ]; then
    if [ -d "${KERNEL_PATH}" ]; then
        echo -e "  Looking in ${G}KERNEL${E} folder ..."
        IMG=$(find "${KERNEL_PATH}" -type f -name "*-${BRD}.wic" -exec basename {} \;)
        case "${IMG}" in
            "core-image-minimal-${BRD}.wic" | "core-image-bsp-${BRD}.wic" | "core-image-weston-${BRD}.wic" | "core-image-qt-${BRD}.wic" )
                echo -e "    Found ${G}${IMG}${E} ... $(realpath ${KERNEL_PATH})${GRAY}/${IMG}${E}"
                KERNEL=${KERNEL_PATH}/${IMG}
            ;;
            *)
                echo -e "    ${R}No img found${E} ... $(realpath ${KERNEL_PATH})"
            ;;
        esac
    else
        echo -e "  Looking in ${G}KERNEL${E} folder ... No ${R}kernel${E} folder"
    fi
fi

if [ -z "${KERNEL}" ]; then
    echo -e "Downloading kernel img ... ${G}https://vekatech.com/VK-RZ_<BRD>_docs/Demo${E}"
    IMGS=(
        "core-image-qt-${BRD}.wic.xz" "core-image-weston-${BRD}.wic.xz" "core-image-bsp-${BRD}.wic.xz" "core-image-minimal-${BRD}.wic.xz"
        "core-image-qt-${BRD}.wic.gz" "core-image-weston-${BRD}.wic.gz" "core-image-bsp-${BRD}.wic.gz" "core-image-minimal-${BRD}.wic.gz"
        "core-image-qt-${BRD}.wic.bz2" "core-image-weston-${BRD}.wic.bz2" "core-image-bsp-${BRD}.wic.bz2" "core-image-minimal-${BRD}.wic.bz2"
        "core-image-qt-${BRD}.wic.zip" "core-image-weston-${BRD}.wic.zip" "core-image-bsp-${BRD}.wic.zip" "core-image-minimal-${BRD}.wic.zip"
    )
    case "${BRD}" in
        "vkrzg2lc")
        KIT=VK-RZ_G2LC_docs
        ;;
        "vkrzg2l" | "vkrzv2l")
        KIT=VK-RZ_V2L_docs
        ;;
        "vkrzg2ul")
        KIT=VK-RZ_G2UL_docs
        ;;
        "vkcmg2lc")
        KIT=VK-CMG2LC_docs
        ;;
        "vk-d184280e"| "vk-d184280e-kd070" | "vk-d184280e-kd070_1" | "vk-d184280e-kd101")
        KIT=VK-D184280E_docs
        ;;
        *)
            echo -e "  No Download link for ${R}${BRD}${E} board !"
            exit 1
        ;;
    esac
    
    if [ ! -d ${KERNEL_PATH} ]; then
        mkdir ${KERNEL_PATH}
    fi

    cd ${KERNEL_PATH}
    for IMG in "${IMGS[@]}"; do
        if wget -q https://vekatech.com/${KIT}/Demo/${IMG}; then
            KERNEL=${KERNEL_PATH}/${IMG%.*}
            break
        else
            echo -e "  Can't reach resource ${R}${IMG}${E}"
        fi
    done

    echo "Extracting kernel img ..."
    case "${IMG}" in
        *.xz)
            xz -d ${IMG}
        ;;
        *.gz)
            gzip -d ${IMG}
        ;;
        *.bz2)
            bzip2 -d ${IMG}
        ;;
        *.zip)
            unzip ${IMG}
            rm "${IMG}"
        ;;
        *)
            echo -e "  Unexpected compression format ${R}${IMG##*.}${E} ..."
        ;;
    esac

    cd ${OLDPWD}
fi

if [ -z "${KERNEL}" ]; then
    echo -e "${R}Can't get any kernel img !${E}"
else
    if [[ "${KERNEL}" == *.wic ]]; then
        DEV=$(sudo losetup -f -P --show ${KERNEL})
        echo -e "Mounting kernel img ... ${G}${DEV}${E}"
        sudo mount ${DEV}p1 /mnt
        mkdir -p ${CACHE_PATH}/${BRD}/boot
        echo -e "  Extracting ${G}boot${E} partition ..."
        cp -a /mnt/* ${CACHE_PATH}/${BRD}/boot/
        case "${BRD}" in
            "vk-d184280e")
                echo -e "    Startup screen ${G}log${E} ... Disabled"
                if grep -q '^extrabootargs=' ${CACHE_PATH}/${BRD}/boot/uEnv.txt; then
                    sed -i '/^extrabootargs=/s|loglevel=3||' ${CACHE_PATH}/${BRD}/boot/uEnv.txt
                    sed -i 's|^extrabootargs=\(.*\)$|extrabootargs=loglevel=3 \1|' ${CACHE_PATH}/${BRD}/boot/uEnv.txt
                else
                    sed -i '/^#extrabootargs=.*$/a \extrabootargs=loglevel=3' ${CACHE_PATH}/${BRD}/boot/uEnv.txt
                fi
            ;;
            *)
                echo -e "    Startup screen ${G}log${E} ... Normal"
            ;;
        esac
        sudo umount /mnt
        sudo mount ${DEV}p2 /mnt
        
        mkdir -p ${CACHE_PATH}/${BRD}/lib
        echo -e "  Extracting ${G}modules${E} ..."
        cp -a /mnt/lib/modules ${CACHE_PATH}/${BRD}/lib/
        case "${BRD}" in
            "vk-d184280e" | "vk-d184280e-kd070" | "vk-d184280e-kd070_1" | "vk-d184280e-kd101")
                mkdir -p ${CACHE_PATH}/${BRD}/lib/firmware
                echo -e "  Extracting ${G}firmware${E} ..."
                if [ -f /mnt/lib/firmware/regulatory.db ]; then
                    cp -a /mnt/lib/firmware/regulatory.db ${CACHE_PATH}/${BRD}/lib/firmware/regulatory.db-yocto
                fi
                if [ -f /mnt/lib/firmware/regulatory.db.p7s ]; then
                    cp -a /mnt/lib/firmware/regulatory.db.p7s ${CACHE_PATH}/${BRD}/lib/firmware/regulatory.db.p7s-yocto
                fi
                if [ -d /mnt/lib/firmware/brcm ]; then
                    cp -a /mnt/lib/firmware/brcm ${CACHE_PATH}/${BRD}/lib/firmware/
                fi
                if [ -d /mnt/lib/firmware/cypress ]; then
                    cp -a /mnt/lib/firmware/cypress ${CACHE_PATH}/${BRD}/lib/firmware/
                fi
            ;;
            *)
                echo -e "  Extracting ${G}firmware${E} ... <${R}No firmware${E} for this board"
            ;;
        esac
        if [ "${BRD}" = "vk-d184280e" ] || [ "$1" = "vkrzg2lc_debian-wl.yaml" ]; then
            echo -e "  Extracting ${G}mali${E} driver ..."
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/include
            if [ -d /mnt/usr/include/CL ]; then
                cp -a /mnt/usr/include/CL ${CACHE_PATH}/${BRD}/usr/local/include/
            fi
            if [ -d /mnt/usr/include/EGL ]; then
                cp -a /mnt/usr/include/EGL ${CACHE_PATH}/${BRD}/usr/local/include/
            fi
            if [ -d /mnt/usr/include/KHR ]; then
                cp -a /mnt/usr/include/KHR ${CACHE_PATH}/${BRD}/usr/local/include/
            fi
            if [ -d /mnt/usr/include/GLES ]; then
                cp -a /mnt/usr/include/GLES ${CACHE_PATH}/${BRD}/usr/local/include/
            fi
            if [ -d /mnt/usr/include/GLES2 ]; then
                cp -a /mnt/usr/include/GLES2 ${CACHE_PATH}/${BRD}/usr/local/include/
            fi
            if [ -d /mnt/usr/include/GLES3 ]; then
                cp -a /mnt/usr/include/GLES3 ${CACHE_PATH}/${BRD}/usr/local/include/
            fi
            LIBDIR=usr/local/lib/mali-G31
            mkdir -p ${CACHE_PATH}/${BRD}/${LIBDIR}
            if [ -f /mnt/usr/lib64/libEGL.so ]; then
                cp -a /mnt/usr/lib64/libEGL.so ${CACHE_PATH}/${BRD}/${LIBDIR}/
                ln -s libEGL.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libEGL.so.1
            fi
            if [ -f /mnt/usr/lib64/libgbm.so ]; then
                cp -a /mnt/usr/lib64/libgbm.so ${CACHE_PATH}/${BRD}/${LIBDIR}/
                ln -s libgbm.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libgbm.so.1
            fi
            if [ -f /mnt/usr/lib64/libGLESv1_CM.so ]; then
                cp -a /mnt/usr/lib64/libGLESv1_CM.so ${CACHE_PATH}/${BRD}/${LIBDIR}/
                ln -s libGLESv1_CM.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libGLESv1_CM.so.1
            fi
            if [ -f /mnt/usr/lib64/libGLESv2.so ]; then
                cp -a /mnt/usr/lib64/libGLESv2.so ${CACHE_PATH}/${BRD}/${LIBDIR}/
                ln -s libGLESv2.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libGLESv2.so.2
            fi
            if [ -f /mnt/usr/lib64/libOpenCL.so ]; then
                cp -a /mnt/usr/lib64/libOpenCL.so ${CACHE_PATH}/${BRD}/${LIBDIR}/
                ln -s libOpenCL.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libOpenCL.so.2
            fi
            if [ -f /mnt/usr/lib64/libwayland-egl.so ]; then
                cp -a /mnt/usr/lib64/libwayland-egl.so ${CACHE_PATH}/${BRD}/${LIBDIR}/
                ln -s libwayland-egl.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libwayland-egl.so.1
            fi
            if [ -d /mnt/usr/lib64/mali_fbdev ]; then
                cp -a /mnt/usr/lib64/mali_fbdev ${CACHE_PATH}/${BRD}/${LIBDIR}/
            fi
            if [ -d /mnt/usr/lib64/mali_wayland ]; then
                cp -a /mnt/usr/lib64/mali_wayland ${CACHE_PATH}/${BRD}/${LIBDIR}/
            fi
            
            if [ -f /mnt/usr/lib64/mali_wayland/libmali.so ]; then
                ln -s mali_wayland/libmali.so ${CACHE_PATH}/${BRD}/${LIBDIR}/libmali.so
            fi
            
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig
            if [ -f /mnt/usr/lib64/pkgconfig/egl.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/egl.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            if [ -f /mnt/usr/lib64/pkgconfig/gbm.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/gbm.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            if [ -f /mnt/usr/lib64/pkgconfig/glesv1.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/glesv1.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            if [ -f /mnt/usr/lib64/pkgconfig/glesv1_cm.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/glesv1_cm.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            if [ -f /mnt/usr/lib64/pkgconfig/glesv2.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/glesv2.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            if [ -f /mnt/usr/lib64/pkgconfig/OpenCL.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/OpenCL.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            if [ -f /mnt/usr/lib64/pkgconfig/wayland-egl.pc ]; then
                cp -a /mnt/usr/lib64/pkgconfig/wayland-egl.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            fi
            echo -e "  Configuring ${G}weston${E} ..."
            mkdir -p ${CACHE_PATH}/${BRD}/etc/default
            cp -a /mnt/etc/default/weston ${CACHE_PATH}/${BRD}/etc/default/
            if ! grep -q '^OPTARGS' "${CACHE_PATH}/${BRD}/etc/default/weston"; then
                echo 'OPTARGS=""' >> ${CACHE_PATH}/${BRD}/etc/default/weston
            fi
            sed -i '/^OPTARGS=/s|"\(.*\)"|"--backend=drm --renderer=gl \1"|' ${CACHE_PATH}/${BRD}/etc/default/weston
            mkdir -p ${CACHE_PATH}/${BRD}/etc/xdg
            cp -a /mnt/etc/xdg/weston ${CACHE_PATH}/${BRD}/etc/xdg/
            sed -i '/^\[output\]$/,${s|^name=.*$|name=DSI-1|;s|^mode=.*$|mode=preferred\n#transform=rotate-xx\n|}' ${CACHE_PATH}/${BRD}/etc/xdg/weston/weston.ini
            mkdir -p ${CACHE_PATH}/${BRD}/lib/systemd/system
            #cp -a /mnt/lib/systemd/system/weston\@.service ${CACHE_PATH}/${BRD}/lib/systemd/system/
            cat > "${CACHE_PATH}/${BRD}/lib/systemd/system/weston@.service" <<EOF
[Unit]
Description=Weston Wayland Compositor
RequiresMountsFor=/run
Conflicts=plymouth-quit.service
After=systemd-user-sessions.service plymouth-quit-wait.service dbus.service multi-user.target

[Service]
User=%i
PAMName=login
EnvironmentFile=-/etc/default/weston
StandardError=journal
PermissionsStartOnly=true
IgnoreSIGPIPE=no

Environment=LD_LIBRARY_PATH=/${LIBDIR}
TTYPath=/dev/tty1
ExecStartPre=/bin/sh -c 'if [ ! -f /var/log/weston.log ]; then install -m 664 -o root -g %i /dev/null /var/log/weston.log; fi'
ExecStart=/usr/bin/weston \$OPTARGS --log=/var/log/weston.log

[Install]
WantedBy=multi-user.target
EOF
        fi
        sudo umount /mnt
        sudo losetup -d ${DEV}
    fi
    if [ "${BRD}" = "vk-d184280e" ]; then
        if [ -d "${APP_PATH}" ]; then
            echo -e "Copping WEBPANEL ${G}APP${E} data ..."
            find "${APP_PATH}" -type d -exec chmod 755 {} +
            cp -a "${APP_PATH}/." "${CACHE_PATH}/${BRD}/"
            find "${CACHE_PATH}/${BRD}/home/vkrz/.config/scripts" -type f -name "*.c" -delete
            find "${CACHE_PATH}/${BRD}/home/vkrz/.config/scripts" -type f -name "Makefile" -delete
            echo -e "  Configuring WEBPANEL ${G}APP${E} launch scripts ..."
            find "${CACHE_PATH}/${BRD}/home/vkrz/.config/scripts" -type f -name "*.sh" -exec chmod +x {} \;
            find "${CACHE_PATH}/${BRD}/home/vkrz/.config/scripts" -type f -name "*.so" -exec chmod +x {} \;
        else
            echo -e "Copping ${G}WEBPANEL${E} data ... No ${R}$(basename "${APP_PATH}")${E} folder"
        fi
    fi

    if ! command -v docker &> /dev/null; then
        echo -e "Checking for ${Y}docker${E} ... ${R}NO${E} ${GRAY}[MISSING]${E}"
        echo -e "  Installing ${M}docker${E} ..."
        echo -e "  ${Y}-------------------${E}"
        sudo apt-get update
        sudo apt-get install ca-certificates -y
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        echo -e "  ${Y}-------------------${E}"
        sudo usermod -aG docker ${USER}
        echo "  Trying docker ..."
        if su - "${USER}" -c 'docker run hello-world | grep "^Hello from Docker!$"'; then
            echo -e "  Nice! Now you have ${G}docker${E}"
            echo -e "  Please log out (typing ${R}exit${E}) & log in, after that, run the ${G}${0}${E} script again, so the group changes to take effect."
            exit 0
        else
            echo -e "  Something got wrong! Please install ${R}docker${E} manually & investigate why hello-world ${R}doesn't${E} work!"
            exit 1
    fi
    else
        echo -e "Checking for ${Y}docker${E} ... ${G}YES${E} ${GRAY}[INSTALLED]${E}"
    fi

    echo -e "\nBuilding ...\n"
    
    if [ ! -d "${SRC}/images/${BRD}" ]; then
        mkdir -p "${SRC}/images/${BRD}"
    fi
    
    docker run --rm --interactive --tty --device /dev/kvm --group-add $(getent group kvm | cut -d: -f3) --user $(id -u) --workdir /recipes --mount "type=bind,source=${SRC},destination=/recipes" --security-opt label=disable godebos/debos --memory 4G --scratchsize 8G $1
    VER=$(sed -n 's/.*\.suite[[:space:]]*"\([^"]*\)".*/\1/p' "$1")
    if [ -f "${SRC}/images/${BRD}/debian-${VER}-${BRD}.img" ]; then
        echo -e "\nGenerating sparsed img ..."
        img2simg ${SRC}/images/${BRD}/debian-${VER}-${BRD}.img ${SRC}/images/${BRD}/debian-${VER}-${BRD}.simg
        if [ "${BRD}" = "vk-d184280e" ] && [ -d "${SIGN_PATH}" ]; then
            echo -e "\nSigning img ..."
            mv ${SRC}/images/${BRD}/debian-${VER}-${BRD}.img ${SIGN_PATH}/img/
            if [ -f "${SRC}/images/${BRD}/debian-${VER}-${BRD}.img.gz" ]; then
                mv ${SRC}/images/${BRD}/debian-${VER}-${BRD}.img.gz ${SIGN_PATH}/img/
                ${SIGN_PATH}/gen_manifest.sh
            fi
        else
            rm ${SRC}/images/${BRD}/debian-${VER}-${BRD}.img
        fi
    fi
    #    xz -dc ${SRC}/images/${BRD}/debian-${VER}-${BRD}.img.xz > /tmp/debian-${VER}-${BRD}.img
    #    img2simg /tmp/debian-${VER}-${BRD}.img ${SRC}/images/${BRD}/debian-${VER}-${BRD}.simg
    #    rm /tmp/debian-${VER}-${BRD}.img
    echo -e "\nDone\n"
fi
