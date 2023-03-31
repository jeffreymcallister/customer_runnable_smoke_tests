apt install yasm
wget https://github.com/FFmpeg/FFmpeg/archive/refs/heads/master.zip
unzip -d ffmpeg master.zip
cd ffmpeg/FFmpeg-master
./configure
./configure --enable-libvpl
make -j
make install

#104  cp /home/gta/oneVPL/examples/content/cars_320x240.h265 .
#  105  ffmpeg -hwaccel qsv -c:v hevc_qsv -i cars_320x240.h265 -f null -
