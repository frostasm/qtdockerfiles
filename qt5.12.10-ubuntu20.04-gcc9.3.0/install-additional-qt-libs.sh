#!/bin/bash

set -x
set -e


if [ $# -lt 2 ];
then
    echo
    echo "install-additional-qt-libs.sh path-to-qt-root-dir qt-version"
    echo " - path-to-qt-root-dir => /opt/Qt"
    echo " - qt-version => 5.11.1"
    echo
    exit 1
fi

QT_ROOT_PATH=$1
QT_VERSION=$2

QT_PATH="${QT_ROOT_PATH}/${QT_VERSION}"
QT_BIN_DIR="${QT_PATH}/gcc_64/bin"
QMAKE_BIN="${QT_BIN_DIR}/qmake"

export PATH=${QT_BIN_DIR}:${PATH}

if [ ! -d "$QT_BIN_DIR" ]; then
    echo
    echo "Qt bin dir not exist: $QT_BIN_DIR"
    echo
    exit 1
fi


if [[ -z "${TMP_INSTALL_DIR}" ]]; then
    echo "TMP_INSTALL_DIR variable not set!"
    exit 1
fi

mkdir -p "${TMP_INSTALL_DIR}"
CPU_COUNT=$(nproc --all --ignore=1)


#-------------------------------- Skycoder42 / QtJsonSerializer --------------------------------
if [[ "${QTJSONSERIALIZER_INSTALL}" == "yes" ]]; then
    echo "Install QtJsonSerializer libs"

    if [[ -z "${QTJSONSERIALIZER_VERSION}" || -z "${QTJSONSERIALIZER_QT_VERSION}" ]]; then
        echo "QtJsonSerializer error: QTJSONSERIALIZER_VERSION and QTJSONSERIALIZER_QT_VERSION variables not set!"
        exit 1
    fi

    TAR_PATH="${TMP_INSTALL_DIR}/QtJsonSerializer.tar.xz"
    curl -L -o "${TAR_PATH}" "https://github.com/Skycoder42/QtJsonSerializer/releases/download/${QTJSONSERIALIZER_VERSION}/build_gcc_64_${QTJSONSERIALIZER_QT_VERSION}.tar.xz"
    tar -xJvf "${TAR_PATH}" -C "${QT_PATH}"
fi # "${QTJSONSERIALIZER_INSTALL}" == "yes" ]];

#--------------------------------  Skycoder42 / QtService  --------------------------------
if [[ "${QTSERVICE_INSTALL}" == "yes" ]]; then
    echo "Install QtService libs"

    if [[ -z "${QTSERVICE_VERSION}" || -z "${QTSERVICE_QT_VERSION}" ]]; then
        echo "QtService error: QTSERVICE_VERSION and QTSERVICE_QT_VERSION variables not set!"
        exit 1
    fi

    TAR_PATH="${TMP_INSTALL_DIR}/QtService.tar.xz"
    curl -L -o "${TAR_PATH}" "https://github.com/Skycoder42/QtService/releases/download/${QTSERVICE_VERSION}/qtservice_gcc_64_${QTSERVICE_QT_VERSION}.tar.xz"
    tar -xJvf "${TAR_PATH}" -C "${QT_PATH}"
fi # "${QTSERVICE_INSTALL}" == "yes" ]];

#------------------------------ QtAV ----------------------------------------
if [[ "${QTAV_INSTALL}" == "yes" ]]; then
    echo "Install QtAV libs"

    QTAV_SRC_DIR=${TMP_INSTALL_DIR}/qtav/src
    QTAV_BUILD_DIR=${TMP_INSTALL_DIR}/qtav/build

    git clone https://github.com/wang-bin/QtAV.git "${QTAV_SRC_DIR}"
    cd "${QTAV_SRC_DIR}"

    if [[ -n "${QTAV_GIT_COMMIT}" ]]; then
        echo "QtAV: checkout commit ${QTAV_GIT_COMMIT}"
        git checkout -b build-branch "${QTAV_GIT_COMMIT}"
    elif [[ -n "${QTAV_GIT_TAG}" ]]; then
        echo "QtAV: checkout tag ${QTAV_GIT_TAG}"
        git checkout "tags/${QTAV_GIT_TAG}" -b build-branch
    else
        echo "Qt AV build error: QTAV_GIT_COMMIT or QTAV_GIT_TAG variable not set!"
        exit 1
    fi

    mkdir -p "${QTAV_BUILD_DIR}"
    cd "${QTAV_BUILD_DIR}"

    ls -lha "${QTAV_SRC_DIR}"
    ${QMAKE_BIN} CONFIG+=no-examples CONFIG+=no-tests "${QTAV_SRC_DIR}/QtAV.pro"
    make "-j${CPU_COUNT}"

    # install QtAV libs
    chmod +x sdk_install.sh 
    sudo ./sdk_install.sh

fi # "${QTAV_INSTALL}" == "yes" ]];


#-------------------------------- LimeReport --------------------------------
if [[ "${LIMEREPORT_INSTALL}" == "yes" ]]; then
    echo "Install LimeReport libs"

    LIME_REPORT_SRC_DIR="${TMP_INSTALL_DIR}/LimeReport/src"
    LIME_REPORT_BUILD_DIR="${TMP_INSTALL_DIR}/LimeReport/build"

    git clone https://github.com/fralx/LimeReport.git "${LIME_REPORT_SRC_DIR}"
    cd "${LIME_REPORT_SRC_DIR}"

    if [[ -n "${LIMEREPORT_GIT_COMMIT}" ]]; then
        git checkout -b build-branch "${LIMEREPORT_GIT_COMMIT}"
    elif [[ -n "${LIMEREPORT_GIT_TAG}" ]]; then
        git checkout "tags/${LIMEREPORT_GIT_TAG}" -b build-branch
    else
        echo "LimeReport build error: LIMEREPORT_GIT_COMMIT or LIMEREPORT_GIT_TAG variable not set!"
        exit 1
    fi

    mkdir -p "${LIME_REPORT_BUILD_DIR}"
    cd "${LIME_REPORT_BUILD_DIR}"

    qmake CONFIG+=no_zint CONFIG+=no_build_translations TOP_BUILD_DIR="${LIME_REPORT_BUILD_DIR}" "${LIME_REPORT_SRC_DIR}/limereport/limereport.pro"
    make "-j${CPU_COUNT}"

    make install

fi # "${LIMEREPORT_INSTALL}" == "yes" ]]
