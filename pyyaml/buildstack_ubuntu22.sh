#!/usr/bin/bash -v
###############################################################################
# Copyright (C) Intel Corporation
#
# SPDX-License-Identifier: MIT
###############################################################################
# Sets up full GPU stack, including latest opensource VPL and FFmpeg-qsv
# Intended OS: Ubuntu 22.04 (system OS or docker container)

#Script must be run as root
if [ `id -u` -ne 0 ] ; then echo "Script must be run as root" ; exit 1 ; fi

export PKG_CONFIG_PATH=/usr/local/share/pkgconfig
export DEBIAN_FRONTEND=noninteractive

#set up build environment
#use a standard cmake across distros
apt update
apt -y install wget

CMAKEFILE=cmake-3.25.1-linux-x86_64.tar.gz
if [ ! -f "$CMAKEFILE" ]; then
    wget https://github.com/Kitware/CMake/releases/download/v3.25.1/$CMAKEFILE
fi
tar -xzf $CMAKEFILE 
cp -r cmake-3.25.1-linux-x86_64/share/* /usr/share/
cp -r cmake-3.25.1-linux-x86_64/bin/* /usr/bin/

apt install -y autoconf build-essential git libtool libx11-xcb1 libxatracker2 libxcb-dri3-0 libxcb-present0 pkg-config python3 python3-pip wget yasm unzip vim virt-what

pip3 install robotframework==4.0.1 meson ninja

VIRTENV=`virt-what`
if [[ ! "$VIRTENV" =~ .*"docker".* ]]; then
  # update kernel (may be necessary on newer HW)
  add-apt-repository -y ppa:cappelikan/ppa
  apt update
  apt -y install mainline
  add-apt-repository -y --remove ppa:cappelikan/ppa
  mainline --install-latest --yes  
fi

rm -rf intel-gpu-firmware
git clone https://github.com/intel-gpu/intel-gpu-firmware
mkdir -p /lib/firmware/updates/i915
cp intel-gpu-firmware/firmware/*.bin /lib/firmware/updates/i915

rm -rf macros
git clone -b util-macros-1.19.3 https://gitlab.freedesktop.org/xorg/util/macros.git && \
    pushd macros && \
    ./autogen.sh && ./configure --prefix=/usr/local && make && make install && \
    popd

rm -rf libpciaccess
git clone -b libpciaccess-0.17 https://gitlab.freedesktop.org/xorg/lib/libpciaccess.git && \
    pushd libpciaccess && \
    meson --prefix=/usr/local --libdir=/usr/local/lib builddir && ninja -C builddir install && \
    popd


rm -rf drm
git clone -b libdrm-2.4.113 https://gitlab.freedesktop.org/mesa/drm.git && \
    pushd drm && \
    meson --prefix=/usr/local --libdir=/usr/local/lib builddir && ninja -C builddir install && \
    popd

rm -rf libva
git clone -b 2.16.0 https://github.com/intel/libva.git && \
    pushd libva && \
    meson --prefix=/usr/local --libdir=/usr/local/lib builddir && ninja -C builddir install && \
    popd

rm -rf libva-utils
git clone -b 2.16.0 https://github.com/intel/libva-utils.git && \
    pushd libva-utils && \
    meson --prefix=/usr/local --libdir=/usr/local/lib builddir && ninja -C builddir install && \
    popd


rm -rf gmmlib
git clone -b intel-gmmlib-22.3.0 https://github.com/intel/gmmlib.git && \
    pushd gmmlib && \
    mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && make -j 8 && make install && \
    popd

#media-driver is the core component of this build
#it requires matching drm, libva, and gmmlib
#driver must be new enough to support VPL and FFmpeg features
rm -rf media-driver
git clone -b intel-media-22.6.1 https://github.com/intel/media-driver.git && \
    pushd media-driver && \
    mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_PRODUCTION_KMD=ON .. && make -j 8 && make install && \
    popd

rm -rf oneVPL-intel-gpu
git clone -b intel-onevpl-22.5.4 https://github.com/oneapi-src/oneVPL-intel-gpu.git && \
    pushd oneVPL-intel-gpu && \
    mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DMFX_ENABLE_AENC=ON .. && make -j 8 && make install && \
    popd


rm -rf oneVPL
git clone https://github.com/oneapi-src/oneVPL.git && \
    pushd oneVPL && \
    mkdir -p build  && cd build && cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local && make -j 8 && make install && \
    popd


rm -rf FFmpeg
git clone https://github.com/FFmpeg/FFmpeg.git && \
    pushd FFmpeg/ && \
    ./configure --enable-libvpl --prefix=/usr/local && \
    make -j 8 && make install
    popd



echo "set library load path:"
echo "export LD_LIBRARY_PATH=/usr/local/lib:\$LD_LIBRARY_PATH"
