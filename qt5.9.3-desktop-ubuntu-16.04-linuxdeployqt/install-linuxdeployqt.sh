#!/bin/sh -x

export DEBIAN_FRONTEND=noninteractive

INSTALL_PATH=/opt/linuxdeployqt
LINUXDEPLOYQT_BINARY=${INSTALL_PATH}/linuxdeployqt

mkdir -p ${INSTALL_PATH}
curl -L -o ${LINUXDEPLOYQT_BINARY} https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage

chmod +x ${LINUXDEPLOYQT_BINARY}

cd ${INSTALL_PATH}
./linuxdeployqt --appimage-extract

chmod  755 -R ${INSTALL_PATH}


APP_RUN=${INSTALL_PATH}/squashfs-root/AppRun

ln -s ${APP_RUN} /usr/bin/linuxdeployqt

rm /opt/Qt/5.9.3/gcc_64/plugins/sqldrivers/libqsqlpsql.so
rm /opt/Qt/5.9.3/gcc_64/plugins/sqldrivers/libqsqlmysql.so
