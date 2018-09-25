#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

INSTALL_PATH=/opt/linuxdeployqt
APP_IMAGE=${INSTALL_PATH}/linuxdeployqt
APP_RUN=${INSTALL_PATH}/squashfs-root/AppRun

mkdir -p ${INSTALL_PATH}
curl -L -o ${APP_IMAGE} https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage

chmod +x ${APP_IMAGE}

cd ${INSTALL_PATH}
./linuxdeployqt --appimage-extract

chmod  755 -R ${INSTALL_PATH}

rm ${APP_IMAGE}

ln -s ${APP_RUN} /usr/bin/linuxdeployqt