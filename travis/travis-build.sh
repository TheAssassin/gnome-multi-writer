#! /bin/bash

set -e
set -x

apt-get update
apt-get install -y python3-pip ninja-build libgtk-3-dev libgusb-dev libudisks2-dev libcanberra-dev libcanberra-dev libcanberra-gtk-dev
pip3 install meson

mkdir build/
cd build/

../configure --prefix=/usr

make -j$(nproc)
make install DESTDIR=$(readlink -f appdir) ; find appdir/

wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage

unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH

export VERSION=$(git rev-parse --short HEAD) # linuxdeployqt uses this for naming the file

./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/*.desktop -bundle-non-qt-libs
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/*.desktop -appimage
