#!/bin/sh

if [ $# -lt 2 ];
then
    echo
    echo "install-additional-qt-libs.sh path-to-qt-root-dir qt-version"
    echo " - path-to-qt-root-dir => /opt/Qt"
    echo " - qt-version => 5.11.1"
    echo
    exit -1
fi

QT_ROOT_PATH=$1
QT_VERSION=$2

QT_PATH=${QT_ROOT_PATH}/${QT_VERSION}
QT_BIN_DIR=${QT_PATH}/gcc_64/bin

export PATH=${QT_BIN_DIR}:${PATH}

if [ ! -d "$QT_BIN_DIR" ]; then
    echo
    echo "Qt bin dir not exist: $QT_BIN_DIR"
    echo
    exit -1
fi

# Install QtJsonSerializer libs
echo "Install QtJsonSerializer libs"
TAR_PATH=/tmp/QtJsonSerializer.tar.xz
curl -L -o ${TAR_PATH} https://github.com/Skycoder42/QtJsonSerializer/releases/download/3.2.0-2/build_gcc_64_5.12.0.tar.xz


tar -xJvf ${TAR_PATH} -C ${QT_PATH}

rm ${TAR_PATH}


echo "Install LimeReport libs"

LIME_REPORT_SRC_DIR=/tmp/qt/build/LimeReport
LIME_REPORT_BUILD_DIR=/tmp/qt/build/LimeReport

git clone --depth=1 https://github.com/fralx/LimeReport.git ${LIME_REPORT_SRC_DIR}
mkdir -p ${LIME_REPORT_BUILD_DIR}

cd ${LIME_REPORT_BUILD_DIR}

qmake CONFIG+=no_zint CONFIG+=no_build_translations TOP_BUILD_DIR=$(pwd) ${LIME_REPORT_SRC_DIR}/limereport/limereport.pro
make -j$(nproc)

make install

chmod 777 /tmp/qt/

echo  "Install lib-thrift 0.9.1"

curl -Lo /tmp/qt/libthrift-dev_0.9.1_amd64.deb http://people.apache.org/~jfarrell/thrift/0.9.1/contrib/deb/ubuntu/12.04/libthrift-dev_0.9.1_amd64.deb
curl -Lo /tmp/qt/libthrift0_0.9.1_amd64.deb http://people.apache.org/~jfarrell/thrift/0.9.1/contrib/deb/ubuntu/12.04/libthrift0_0.9.1_amd64.deb

sudo dpkg -i --ignore-depends=libqtcore4,libqt4-network /tmp/qt/libthrift0_0.9.1_amd64.deb
sudo dpkg -i --ignore-depends=libglib2.0-dev /tmp/qt/libthrift-dev_0.9.1_amd64.deb
