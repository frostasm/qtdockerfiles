#!/bin/sh -e

if [ $# -lt 2 ];
then
    echo
    echo "install-libs.sh path-to-qt-root-dir qt-version"
    echo " - path-to-qt-root-dir => /opt/Qt"
    echo " - qt-version => 5.9.3"
    echo
    exit -1
fi

QT_ROOT_PATH=$1
QT_VERSION=$2

QT_BIN_DIR=${QT_ROOT_PATH}/${QT_VERSION}/gcc_64/bin
export PATH=${QT_BIN_DIR}:${PATH}

if [ ! -d "$QT_BIN_DIR" ]; then
    echo
    echo "Qt bin dir not exist: $QT_BIN_DIR"
    echo
    exit -1
fi

# install QtJsonSerializer libs
echo "Install QtJsonSerializer libs"
TAR_NAME=QtJsonSerializer.tar.xz
curl -L -o ${TAR_NAME} https://github.com/Skycoder42/QtJsonSerializer/releases/download/3.1.0-2/build_gcc_64_${QT_VERSION}.tar.xz
sudo tar -xJvf ${TAR_NAME} -C ${QT_ROOT_PATH}


# build QtAV libs
echo "Install QtAV libs"
git clone https://github.com/wang-bin/QtAV.git
cd QtAV
git checkout -b build-branch 49ce5f8a0f0aee52e263da0581a4f66723543567
cd ..

mkdir build
cd build
qmake ../QtAV/QtAV.pro
make

# install QtAV libs
chmod +x sdk_install.sh 
sudo ./sdk_install.sh