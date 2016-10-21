#!/bin/bash

apt-get update && \
apt-get install -y  \
autoconf \
automake \
bzip2 \
g++ \
git \
gstreamer1.0-plugins-good \
gstreamer1.0-tools \
gstreamer1.0-pulseaudio \
gstreamer1.0-plugins-bad \
gstreamer1.0-plugins-base \
gstreamer1.0-plugins-ugly  \
libatlas3-base \
libgstreamer1.0-dev \
libtool-bin \
make \
nfs-common \
python2.7 \
python-pip \
python-yaml \
python-simplejson \
python-gi \
subversion \
supervisor \
wget \
zlib1g-dev && \
apt-get clean autoclean && \
apt-get autoremove -y && \
pip install ws4py==0.3.2 && \
pip install tornado && \
pip install awscli && \
ln -s /usr/bin/python2.7 /usr/bin/python ; ln -s -f bash /bin/sh && \
cd /opt && wget http://www.digip.org/jansson/releases/jansson-2.7.tar.bz2 && \
bunzip2 -c jansson-2.7.tar.bz2 | tar xf -  && \
cd jansson-2.7 && \
./configure && \
make && \
make check && \
make install && \
echo "/usr/local/lib" >> /etc/ld.so.conf.d/jansson.conf && \
ldconfig && \
rm /opt/jansson-2.7.tar.bz2 && \
rm -rf /opt/jansson-2.7 && \
cd /opt && \
git clone https://github.com/kaldi-asr/kaldi && \
cd /opt/kaldi/tools && \
make && \
./install_portaudio.sh && \
cd /opt/kaldi/src && \
./configure --shared && \
sed -i '/-g # -O0 -DKALDI_PARANOID/c\-O3 -DNDEBUG' kaldi.mk && \
make depend && \
make && \
cd /opt/kaldi/src/online && \
make depend && \
make && \
cd /opt/kaldi/src/gst-plugin && \
make depend && \
make && \
cd /opt && \
git clone https://github.com/skoocda/gst-kaldi-nnet2-online.git && \
rm -rf /opt/gst-kaldi-nnet2-online/demo && \
cd /opt/gst-kaldi-nnet2-online/src && \
sed -i '/KALDI_ROOT?=\/home\/tanel\/tools\/kaldi-trunk/c\KALDI_ROOT?=\/opt\/kaldi' Makefile && \
make depend && \
make && \
rm -rf /opt/gst-kaldi-nnet2-online/.git/ && \
find /opt/gst-kaldi-nnet2-online/src/ -type f -not -name '*.so' -delete && \
rm -rf /opt/kaldi/.git /opt/kaldi/egs/ /opt/kaldi/windows/ /opt/kaldi/misc/ && \
find /opt/kaldi/src/ -type f -not -name '*.so' -delete && \
find /opt/kaldi/tools/ -type f \( -not -name '*.so' -and -not -name '*.so*' \) -delete && \
cd /opt && \
git clone https://github.com/skoocda/kaldi-gstreamer-server.git && \
rm -rf /opt/kaldi-gstreamer-server/.git/ && \
rm -rf /opt/kaldi-gstreamer-server/test/models/english/voxforge/ && \
rm -rf /opt/kaldi-gstreamer-server/test/data/ && \
mkdir -p /opt/models/english && cd /opt/models/english && \
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 \
$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone).fs-7a07d233.efs.us-east-1.amazonaws.com:/ . && \
wget https://raw.githubusercontent.com/skoocda/kaldi-gstreamer-server/master/multi.yaml -P /opt/models/english && \
rm /var/lib/apt/lists/* && \
cat >> /etc/supervisor/conf./supervisord.conf <<EOT
[supervisord]
nodaemon=true
[program:worker]
environment=GST_PLUGIN_PATH=/opt/gst-kaldi-nnet2-online/src/:/opt/kaldi/src/gst-plugin/
command=python /opt/kaldi-gstreamer-server/kaldigstserver/worker.py -c /opt/models/english/multi.yaml -u ws://52.45.237.54/worker/ws/speech
numprocs=1
autostart=true
autorestart=true
stderr_logfile=/opt/worker.log
EOT
/usr/bin/supervisord
