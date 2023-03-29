if (( $EUID != 0 )); then
    echo "Script must be run as root"
    exit
fi

apt-get update

apt install -y python3 python3-pip opencl-headers libpugixml-dev libtbb-dev libtbb2
pip install openvino-dev[caffe]==2022.3.0

curl -L https://storage.openvinotoolkit.org/repositories/openvino/packages/2022.3/linux/l_openvino_toolkit_ubuntu20_2022.3.0.9052.9752fafe8eb_x86_64.tgz --output openvino_2022.3.0.tgz
tar -xf openvino_2022.3.0.tgz
mkdir -p /opt/intel
mv l_openvino_toolkit_ubuntu20_2022.3.0.9052.9752fafe8eb_x86_64 /opt/intel/openvino_2022.3.0
ln -s /opt/intel/openvino_2022.3.0 /opt/intel/openvino_2022
