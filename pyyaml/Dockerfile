FROM ubuntu:22.04

#----
# build mediadriver_stack component setup
#----
RUN apt update
RUN apt install -y meson ninja-build autogen autoconf cmake build-essential git libtool libx11-xcb1 libxatracker2 libxcb-dri3-0 libxcb-present0 pkg-config python3 python3-pip wget yasm unzip vim


#----
# build mediadriver_stack component util-macros
#----
RUN git clone  -b util-macros-1.20.0 https://gitlab.freedesktop.org/xorg/util/macros.git && \ 
    cd macros && \ 
    ./autogen.sh && \ 
    ./configure --prefix=/usr/local && \ 
     make && make install 

#----
# build mediadriver_stack component libpciaccess
#----
RUN git clone  -b libpciaccess-0.17 https://gitlab.freedesktop.org/xorg/lib/libpciaccess.git && \ 
    cd libpciaccess && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install  


#----
# build mediadriver_stack component libdrm
#----
RUN git clone  -b libdrm-2.4.115 https://gitlab.freedesktop.org/mesa/drm.git && \ 
    cd drm && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install  


#----
# build mediadriver_stack component libva
#----
RUN git clone  -b 2.17.0 https://github.com/intel/libva.git && \ 
    cd libva && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install  


#----
# build mediadriver_stack component libva-utils
#----
RUN git clone  -b 2.17.0 https://github.com/intel/libva-utils.git && \ 
    cd libva-utils && \ 
    meson --prefix=/usr/local--libdir=/usr/local/lib builddir && \ 
    ninja -C builddir install  


#----
# build mediadriver_stack component gmmlib
#----
RUN git clone  -b intel-gmmlib-22.3.3 https://github.com/intel/gmmlib.git && \ 
    cd gmmlib && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 


#----
# build mediadriver_stack component intel-media-driver
#----
RUN git clone  -b intel-media-22.6.5 https://github.com/intel/media-driver.git && \ 
    cd media-driver && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 


#----
# build mediadriver_stack component intel-onevpl-gpu
#----
RUN git clone  -b intel-onevpl-22.6.5 https://github.com/oneapi-src/oneVPL-intel-gpu.git && \ 
    cd oneVPL-intel-gpu && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 


#----
# build mediadriver_stack component intel-onevpl-dispatcher
#----
RUN git clone  -b v2023.1.3 https://github.com/oneapi-src/oneVPL.git && \ 
    cd oneVPL && \ 
    mkdir -p build && cd build && \ 
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. && \ 
    make -j && make install 


