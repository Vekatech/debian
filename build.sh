#!/bin/bash
R='\033[0;31m'
G='\033[0;32m'
Y='\033[0;33m'
#B='\033[0;34m'
GRAY='\033[0;90m'
E='\033[0m'

BLACK_BG='\033[0;40m'

if [ $# -ne 1 ]; then
    echo "Usage: $0 <RECIPE.yaml>"
    exit 1
else
    BRD=vkrz${1%%_*} 
    echo -e "\nBuilding debian for ${G}${BRD}${E} board\n"
fi

KERNEL_PATH=$(dirname $(realpath $0))/kernel
CACHE_PATH=$(dirname $(realpath $0))/overlays/boards
YOCTO_PATH=$(dirname $(realpath $0))/../${BRD}/vlp_305/yocto/yocto_305/build/tmp/deploy/images

KERNEL=

echo "Checking for kernel img ..."
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
        IMG=$(find "${YOCTO_PATH}/${BRD}" -type f -name "*-${BRD}.wic" -exec basename {} \;)
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
        sudo umount /mnt
        sudo mount ${DEV}p2 /mnt
        mkdir -p ${CACHE_PATH}/${BRD}/lib
        echo -e "  Extracting ${G}modules${E} ..."
        cp -a /mnt/lib/modules ${CACHE_PATH}/${BRD}/lib/
        if [ "$1" = "g2lc_debian_wl.yaml" ]; then
            echo -e "  Extracting ${G}mali${E} driver ..."
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/include
            cp -a /mnt/usr/include/CL ${CACHE_PATH}/${BRD}/usr/local/include/
            cp -a /mnt/usr/include/EGL ${CACHE_PATH}/${BRD}/usr/local/include/
            cp -a /mnt/usr/include/KHR ${CACHE_PATH}/${BRD}/usr/local/include/
            cp -a /mnt/usr/include/GLES ${CACHE_PATH}/${BRD}/usr/local/include/
            cp -a /mnt/usr/include/GLES2 ${CACHE_PATH}/${BRD}/usr/local/include/
            cp -a /mnt/usr/include/GLES3 ${CACHE_PATH}/${BRD}/usr/local/include/
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/lib
            cp -a /mnt/usr/lib64/libEGL.so ${CACHE_PATH}/${BRD}/usr/local/lib/
            cp -a /mnt/usr/lib64/libgbm.so ${CACHE_PATH}/${BRD}/usr/local/lib/
            cp -a /mnt/usr/lib64/libGLESv1_CM.so ${CACHE_PATH}/${BRD}/usr/local/lib/
            cp -a /mnt/usr/lib64/libGLESv2.so ${CACHE_PATH}/${BRD}/usr/local/lib/
            cp -a /mnt/usr/lib64/libOpenCL.so ${CACHE_PATH}/${BRD}/usr/local/lib/
            cp -a /mnt/usr/lib64/libwayland-egl.so ${CACHE_PATH}/${BRD}/usr/local/lib/
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/lib/mali_fbdev
            cp -a /mnt/usr/lib64/mali_fbdev/libmali.so ${CACHE_PATH}/${BRD}/usr/local/lib/mali_fbdev/
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/lib/mali_wayland
            cp -a /mnt/usr/lib64/mali_wayland/libmali.so ${CACHE_PATH}/${BRD}/usr/local/lib/mali_wayland/
            mkdir -p ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig
            cp -a /mnt/usr/lib64/pkgconfig/egl.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            cp -a /mnt/usr/lib64/pkgconfig/gbm.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            cp -a /mnt/usr/lib64/pkgconfig/glesv1.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            cp -a /mnt/usr/lib64/pkgconfig/glesv1_cm.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            cp -a /mnt/usr/lib64/pkgconfig/glesv2.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            cp -a /mnt/usr/lib64/pkgconfig/OpenCL.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            cp -a /mnt/usr/lib64/pkgconfig/wayland-egl.pc ${CACHE_PATH}/${BRD}/usr/local/lib/pkgconfig/
            echo -e "  Configuring ${G}weston${E} ..."
            mkdir -p ${CACHE_PATH}/${BRD}/etc/default
            echo 'OPTARGS="--idle-time=0"' > ${CACHE_PATH}/${BRD}/etc/default/weston
            mkdir -p ${CACHE_PATH}/${BRD}/etc/xdg/weston
            cp -a /mnt/etc/xdg/weston/weston.ini ${CACHE_PATH}/${BRD}/etc/xdg/weston/
            sed -i '/weston-terminal$/,${/^\[launcher\]$/{N;N;N;d}}' ${CACHE_PATH}/${BRD}/etc/xdg/weston/weston.ini
            mkdir -p ${CACHE_PATH}/${BRD}/lib/systemd/system
            cp -a /mnt/lib/systemd/system/weston@.service ${CACHE_PATH}/${BRD}/lib/systemd/system/
            sed -i 's|^ExecStart=.*$|TTYPath=/dev/tty1\nExecStartPre=/bin/sh -c '\''if [ ! -f /var/log/weston.log ]; then install -m 664 -o root -g %i /dev/null /var/log/weston.log; fi'\''\nExecStart=/usr/bin/weston $OPTARGS --log=/var/log/weston.log\n\n[Install]\nWantedBy=multi-user.target|' ${CACHE_PATH}/${BRD}/lib/systemd/system/weston@.service
            #settt
        fi
        sudo umount /mnt
        sudo losetup -d ${DEV}
    fi

    if ! command -v docker &> /dev/null; then
        echo -e "Checking for Docker ... ${R}NO${E} ${GRAY}[MISSING]${E}"
        read -p "  Do you want to install it? (Y/n) " answer
        if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
            sudo apt-get update
            sudo apt-get install ca-certificates curl
            sudo install -m 0755 -d /etc/apt/keyrings
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
            sudo chmod a+r /etc/apt/keyrings/docker.asc
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
            sudo usermod -aG docker ${USER}
            echo "  Relogging ... to refresh the groups"
            su - ${USER}
            if docker run hello-world | grep "^Hello from Docker!$"; then
                echo -e "  Nice! Now you have ${G}Docker${E}"
            else
                echo -e "  Please reinstall Docker manually & investigate why hello-world ${R}does't${E} work! For more info check this: ${G}https://github.com/renesas-rz/docker_setup${E}"
                exit 1
            fi
        else
            echo -e "  OK install it yourself, but make sure it's setupped this way: ${G}https://github.com/renesas-rz/docker_setup${E}"
            exit 1
        fi
    else
        echo -e "Checking for Docker ... ${G}YES${E} ${GRAY}[INSTALLED]${E}"
    fi

    echo -e "\nBuilding ...\n"
    docker run --rm --interactive --tty --device /dev/kvm --group-add $(getent group kvm | cut -d: -f3) --user $(id -u) --workdir /recipes --mount "type=bind,source=$(pwd),destination=/recipes" --security-opt label=disable godebos/debos $1
fi
