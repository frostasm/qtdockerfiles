FROM ubuntu:18.04
MAINTAINER frostasm <frostasm@gmail.com>

ARG QT_VERSION=5.12.0
ARG QT_DOWNLOAD_BASE_URL=https://download.qt.io

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/${QT_VERSION}/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * build-essential, pkg-config, libgl1-mesa-dev - basic Qt build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3 - dependencies of the Qt bundle run-file
#  * libxi6, libgconf-2-4, libgtk-3-0, libx11-xcb1, libpq5, file - dependencies of the linuxdeployqt

RUN apt update && apt full-upgrade -y && apt install -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    locales \
    sudo \
    curl \
    build-essential \
    gcc-multilib \
    g++-multilib \
    pkg-config \
    libgl1-mesa-dev \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    libdbus-1-3 \
    \
    libboost-all-dev \
    \
    libxi6 \
    libgconf-2-4 \
    libgtk-3-0 \
    libx11-xcb1 \
    libpq5 \
    file \
    \
    libpoppler-qt5-dev \
    libopencv-dev \
    libzbar-dev \
    libkf5solid-dev \
    libkf5archive-dev \
    \
    bison \
    libssl-dev \
    libxcursor-dev \
    libxcomposite-dev \
    libxdamage-dev \
    libxrandr-dev \
    libfontconfig1-dev \
    libxss-dev \
    libsrtp0-dev \
    libwebp-dev \
    libjsoncpp-dev \
    libopus-dev \
    libminizip-dev \
    libavutil-dev \
    libavformat-dev \
    libavcodec-dev \
    libevent-dev \
    libasound2-dev \
    libbz2-dev \
    libcap-dev \
    libcups2-dev \
    libdrm-dev \
    libegl1-mesa-dev \
    libgcrypt11-dev \
    libnss3-dev \
    libpci-dev \
    libpulse-dev \
    libudev-dev \
    libxtst-dev \
    \
    && apt-get -qq clean


COPY extract-qt-installer.sh install-linuxdeployqt.sh install-additional-qt-libs.sh /tmp/qt/


# Download & unpack Qt toolchains
# Download & unpack linuxdeployqt
# Download & unpack QtJsonSerializer
# Clean

RUN curl -Lo /tmp/qt/installer.run "${QT_DOWNLOAD_BASE_URL}/official_releases/qt/$(echo "${QT_VERSION}" | cut -d. -f 1-2)/${QT_VERSION}/qt-opensource-linux-x64-${QT_VERSION}.run" \
    && export QT_VER=$(echo "${QT_VERSION}" | tr -d .) \
    && export QT_CI_PACKAGES=qt.qt5.$QT_VER.gcc_64,qt.qt5.$QT_VER.qtcharts,qt.qt5.$QT_VER.qtdatavis3d,qt.qt5.$QT_VER.qtpurchasing,qt.qt5.$QT_VER.qtvirtualkeyboard,qt.qt5.$QT_VER.qtwebengine,qt.qt5.$QT_VER.qtnetworkauth,qt.qt5.$QT_VER.qtwebglplugin,qt.qt5.$QT_VER.qtscript \
    && /tmp/qt/extract-qt-installer.sh /tmp/qt/installer.run "$QT_PATH" \
    && find "$QT_PATH" -mindepth 1 -maxdepth 1 ! -name "${QT_VERSION}" -exec echo 'Cleaning Qt SDK: {}' \; -exec rm -r '{}' \;  \
    && /tmp/qt/install-linuxdeployqt.sh \
    && /tmp/qt/install-additional-qt-libs.sh "${QT_PATH}" "${QT_VERSION}" \
    && rm -rf /tmp/qt

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
