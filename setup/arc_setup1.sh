if (( $EUID != 0 )); then
    echo "Script must be run as root"
    exit
fi

source setproxy.sh
apt update
apt install -y gpg-agent wget
wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
echo 'deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu jammy arc' | tee  /etc/apt/sources.list.d/intel.gpu.jammy.list

apt-get update && sudo apt-get install  -y --install-suggests  linux-image-5.17.0-1020-oem

sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"1> $(echo $(($(awk -F\' '/menuentry / {print $2}' /boot/grub/grub.cfg \
| grep -no '5.17.0-1020' | sed 's/:/\n/g' | head -n 1)-2)))\"/" /etc/default/grub

update-grub

echo 'Reboot system for changes to take effect'
