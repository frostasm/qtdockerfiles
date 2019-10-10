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


QMAKE_BIN=qmake

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

#----------------------------------------------------------------------

TMP_DIR=/tmp/qt

mkdir -p ${TMP_DIR}

# Install QtJsonSerializer libs
echo "Install QtJsonSerializer libs"
TAR_PATH=${TMP_DIR}/QtJsonSerializer.tar.xz
curl -L -o ${TAR_PATH} https://github.com/Skycoder42/QtJsonSerializer/releases/download/3.1.0-2/build_gcc_64_5.9.3.tar.xz

tar -xJvf ${TAR_PATH} -C ${QT_PATH}

#----------------------------------------------------------------------

# build QtAV libs
echo "Install QtAV libs"
QT_AV_ROOT_DIR=${TMP_DIR}/qtav

mkdir -p ${QT_AV_ROOT_DIR}
cd ${QT_AV_ROOT_DIR}

git clone https://github.com/wang-bin/QtAV.git
cd QtAV
git checkout -b build-branch 49ce5f8a0f0aee52e263da0581a4f66723543567

cd ${QT_AV_ROOT_DIR}
mkdir build
cd build
${QMAKE_BIN} ${QT_AV_ROOT_DIR}/QtAV/QtAV.pro
make -j$(nproc --all --ignore=1)

# install QtAV libs
chmod +x sdk_install.sh 
sudo ./sdk_install.sh


#----------------------------------------------------------------------
# Install QtFtp libs
echo "Install QtFtp libs"

QT_FTP_ROOT_DIR=${TMP_DIR}/qtftp

mkdir -p ${QT_FTP_ROOT_DIR}
cd ${QT_FTP_ROOT_DIR}

git clone https://github.com/qt/qtftp.git
cd qtftp
git checkout -b build-branch master

# Build shared library
# sed -i 's/CONFIG += static/CONFIG -= static/' src/qftp/qftp.pro
# sed -i 's/CONFIG -= shared/CONFIG += shared/' src/qftp/qftp.pro

cd ${QT_FTP_ROOT_DIR}
mkdir build
cd build

${QMAKE_BIN} ${QT_FTP_ROOT_DIR}/qtftp/qtftp.pro
make
make install

rm -rf ${QT_FTP_ROOT_DIR}