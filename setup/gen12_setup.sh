if (( $EUID != 0 )); then
    echo "Script must be run as root"
    exit
fi

apt update
apt install -y gpg-agent wget
wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
echo 'deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy arc' | tee  /etc/apt/sources.list.d/intel.gpu.jammy.list


apt-get update

apt-get install -y \
  intel-opencl-icd intel-level-zero-gpu level-zero \
  intel-media-va-driver-non-free libmfx1 libmfxgen1 libvpl2 \
  libegl-mesa0 libegl1-mesa libegl1-mesa-dev libgbm1 libgl1-mesa-dev libgl1-mesa-dri \
  libglapi-mesa libgles2-mesa-dev libglx-mesa0 libigdgmm12 libxatracker2 mesa-va-drivers \
  mesa-vdpau-drivers mesa-vulkan-drivers va-driver-all vainfo \
  libigc-dev \
  intel-igc-cm \
  libigdfcl-dev \
  libigfxcmrt-dev \
  level-zero-dev \
  libdrm-dev wayland-protocols libx11-dev libx11-xcb-dev libxcb-present-dev libxcb-dri3-dev \
  cmake build-essential pkg-config libva-dev libva-drm2 net-tools ifupdown \
  libvpl-dev libvpl-tools python3 python3-pip


echo 'Reboot system for changes to take effect'
