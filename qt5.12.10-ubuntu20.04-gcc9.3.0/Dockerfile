FROM ubuntu:20.04
MAINTAINER frostasm <frostasm@gmail.com>

ARG QT_VERSION=5.12.10 \
    QT_BASE_PATH=/opt/Qt

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="${QT_BASE_PATH}/${QT_VERSION}/gcc_64/bin:${PATH}"

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * build-essential, pkg-config, libgl1-mesa-dev - basic Qt build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3 - dependencies of the Qt bundle run-file
#  * libxi6, libgconf-2-4, libgtk-3-0, libx11-xcb1, libpq5, file - dependencies of the linuxdeployqt
#  * python3 python3-pip - aqt (Another Qt installer)

RUN apt update && apt full-upgrade -y && apt install -y --no-install-recommends \
    \
    bison \
    build-essential \
    ca-certificates \
    curl \
    file \
    g++-multilib \
    gcc-multilib \
    git \
    locales \
    mesa-common-dev \
    openssh-client \
    pkg-config \
    sudo \
    \
    libdbus-1-3 \
    libfontconfig1 \
    libgl1-mesa-dev \
    libice6 \
    libsm6 \
    libxext6 \
    libxrender1 \
    \
    libgconf-2-4 \
    libgtk-3-0 \
    libpq5 \
    libx11-xcb1 \
    libxi6 \
    \
    libasound2-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavresample-dev \
    libavutil-dev \
    libbz2-dev \
    libcap-dev \
    libcups2-dev \
    libdrm-dev \
    libegl1-mesa-dev \
    libevent-dev \
    libfontconfig1-dev \
    libgcrypt20-dev \
    libjsoncpp-dev \
    libminizip-dev \
    libnss3-dev \
    libopus-dev \
    libpci-dev \
    libpulse-dev \
    libssl-dev \
    libudev-dev \
    libwebp-dev \
    libxcomposite-dev \
    libxcursor-dev \
    libxdamage-dev \
    libxext-dev \
    libxrandr-dev \
    libxss-dev \
    libxtst-dev \
    \
    libboost-all-dev \
    libopencv-dev \
    \
    libkf5archive-dev \
    libkf5solid-dev \
    libpoppler-qt5-dev \
    libzbar-dev \
    \
    libexif-dev \
    libgdal-dev \
    libglm-dev \
    zlib1g-dev \
    libgst-dev \
    libgstreamer1.0-dev \
    gstreamer1.0-plugins-base \
    libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-vaapi \
    \
    python3 python3-pip \
    \
    && apt-get -qq clean \
    \
    && pip3 install aqtinstall \
    && aqt install -O "${QT_BASE_PATH}" "${QT_VERSION}" linux desktop gcc_64

ARG LINUXDEPLOYQT_VERSION=6 \
    \
    QTJSONSERIALIZER_INSTALL=yes \
    QTJSONSERIALIZER_VERSION=3.2.0-2 \
    QTJSONSERIALIZER_QT_VERSION=5.12.0 \
    \
    QTSERVICE_INSTALL=yes \
    QTSERVICE_VERSION=1.1.1 \
    QTSERVICE_QT_VERSION=5.12.1 \
    \
    QTAV_INSTALL=yes \
    QTAV_GIT_COMMIT=49ce5f8a0f0aee52e263da0581a4f66723543567 \
    QTAV_GIT_TAG= \
    \
    LIMEREPORT_INSTALL=yes \
    LIMEREPORT_GIT_COMMIT= \
    LIMEREPORT_GIT_TAG=1.5.79 \
    \
    TMP_INSTALL_DIR=/tmp/qt

COPY install-linuxdeployqt.sh install-additional-qt-libs.sh /tmp/qt/

RUN /tmp/qt/install-linuxdeployqt.sh \
    && /tmp/qt/install-additional-qt-libs.sh "${QT_BASE_PATH}" "${QT_VERSION}" \
    && rm -rf "${TMP_INSTALL_DIR}"

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user \
    QT_PLUGIN_PATH=/opt/Qt/5.12.10/gcc_64/plugins/ \
    QML2_IMPORT_PATH=/opt/Qt/5.12.10/gcc_64/qml/

