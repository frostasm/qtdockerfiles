#!/bin/sh

sudo chmod 777 /tmp/qt/

echo  "Install lib-thrift 0.9.1"

curl -Lo /tmp/qt/libthrift-dev_0.9.1_amd64.deb http://people.apache.org/~jfarrell/thrift/0.9.1/contrib/deb/ubuntu/12.04/libthrift-dev_0.9.1_amd64.deb
curl -Lo /tmp/qt/libthrift0_0.9.1_amd64.deb http://people.apache.org/~jfarrell/thrift/0.9.1/contrib/deb/ubuntu/12.04/libthrift0_0.9.1_amd64.deb

sudo dpkg -i --ignore-depends=libqtcore4,libqt4-network /tmp/qt/libthrift0_0.9.1_amd64.deb
sudo dpkg -i --ignore-depends=libglib2.0-dev /tmp/qt/libthrift-dev_0.9.1_amd64.deb

rm -f /tmp/qt/libthrift0_0.9.1_amd64.deb
rm -f /tmp/qt/libthrift-dev_0.9.1_amd64.deb

echo "Install LimeReport libs"

LIME_REPORT_SRC_DIR=/tmp/qt/build/LimeReport
LIME_REPORT_BUILD_DIR=/tmp/qt/build/LimeReport

git clone --depth=1 https://github.com/fralx/LimeReport.git ${LIME_REPORT_SRC_DIR}
mkdir -p ${LIME_REPORT_BUILD_DIR}

cd ${LIME_REPORT_BUILD_DIR}

qmake CONFIG+=no_zint CONFIG+=no_build_translations ${LIME_REPORT_SRC_DIR}/limereport/limereport.pro
make -j$(nproc)

sudo make install
