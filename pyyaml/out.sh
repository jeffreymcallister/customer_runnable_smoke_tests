#----
# build kernel_and_firmware component setup
#----
apt update
apt install -y git virt-what


#----
# build kernel_and_firmware component update-kernel
#----
VIRTENV=`virt-what`
if [[ ! "$VIRTENV" =~ .*"docker".* ]]; then
   add-apt-repository -y ppa:cappelikan/ppa
   apt update && apt -y install mainline
   add-apt-repository -y --remove ppa:cappelikan/ppa
   mainline --install-latest --yes
fi


#----
# build kernel_and_firmware component intel-gpu-firmware
#----
git clone https://github.com/intel-gpu/intel-gpu-firmware
mkdir -p /lib/firmware/updates/i915
cp intel-gpu-firmware/firmware/*.bin /lib/firmware/updates/i915


#----
# build mediadriver_stack component setup
#----
apt update
apt install -y autoconf build-essential git libtool libx11-xcb1 libxatracker2 libxcb-dri3-0 libxcb-present0 pkg-config python3 python3-pip wget yasm unzip vim
pip3 install robotframework==4.0.1 meson ninja


#----
# build mediadriver_stack component util-macros
#----
git clone  -b util-macros-1.20.0 https://gitlab.freedesktop.org/xorg/util/macros.git && \ 
    pushd macros && \ 
    ./autogen.sh && \ 
    ./configure --prefix=/usr/local && \ 
     make && make install     popd 


#----
# build mediadriver_stack component libdrm
#----
git clone  -b libdrm-2.4.115 https://gitlab.freedesktop.org/mesa/drm.git && \ 
    pushd drm && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install && \ 
    popd 


#----
# build mediadriver_stack component libva
#----
git clone  -b 2.17.0 https://github.com/intel/libva.git && \ 
    pushd libva && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install && \ 
    popd 


#----
# build mediadriver_stack component libva-utils
#----
git clone  -b 2.17.0 https://github.com/intel/libva-utils.git && \ 
    pushd libva-utils && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install && \ 
    popd 


#----
# build mediadriver_stack component gmmlib
#----
git clone  -b intel-gmmlib-22.3.3 https://github.com/intel/gmmlib.git && \ 
    pushd gmmlib && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 
    popd 


#----
# build mediadriver_stack component intel-media-driver
#----
git clone  -b intel-media-22.6.5 https://github.com/intel/media-driver.git && \ 
    pushd media-driver && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 
    popd 


#----
# build mediadriver_stack component intel-onevpl-gpu
#----
git clone  -b intel-onevpl-22.6.5 https://github.com/oneapi-src/oneVPL-intel-gpu.git && \ 
    pushd oneVPL-intel-gpu && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 
    popd 


#----
# build mediadriver_stack component intel-onevpl-dispatcher
#----
git clone  -b v2023.1.3 https://github.com/oneapi-src/oneVPL.git && \ 
    pushd oneVPL && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 
    popd 


