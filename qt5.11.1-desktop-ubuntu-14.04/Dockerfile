FROM ubuntu:14.04
MAINTAINER frostasm <frostasm@gmail.com>

ARG QT_VERSION=5.11.1

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/${QT_VERSION}/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

# Install updates & requirements:
#  * git, openssh-client, ca-certificates - clone & build
#  * locales, sudo - useful to set utf-8 locale & sudo usage
#  * curl - to download Qt bundle
#  * build-essential, pkg-config, libgl1-mesa-dev - basic Qt build requirements
#  * gcc updated to version 5.x - support C++14 standard - https://gist.github.com/application2000/73fd6f4bf1be6600a2cf9f56315a2d91
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1, libdbus-1-3 - dependencies of the Qt bundle run-file
#  * libxi6, libgconf-2-4, libgtk-3-0, libx11-xcb1, libpq5 - dependencies of the linuxdeployqt
RUN \
    apt-get update && apt full-upgrade -y \
    && apt-get install -y --no-install-recommends software-properties-common ca-certificates \
    && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends gcc-snapshot \
    && apt-get update \
    && apt-get install -y --no-install-recommends gcc-5 g++-5 \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 --slave /usr/bin/g++ g++ /usr/bin/g++-5 \
    && apt-get install -y --no-install-recommends build-essential \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8 \
    && apt-get install -y --no-install-recommends \
        git \
        openssh-client \
        locales \
        sudo \
        curl \
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
        \
    && apt-get -qq clean


COPY extract-qt-installer.sh /tmp/qt/

# Download & unpack Qt toolchains && Clean
RUN curl -Lo /tmp/qt/installer.run "https://download.qt.io/official_releases/qt/$(echo "${QT_VERSION}" | cut -d. -f 1-2)/${QT_VERSION}/qt-opensource-linux-x64-${QT_VERSION}.run" \
    && QT_CI_PACKAGES=qt.qt5.$(echo "${QT_VERSION}" | tr -d .).gcc_64 /tmp/qt/extract-qt-installer.sh /tmp/qt/installer.run "$QT_PATH" \
    && find "$QT_PATH" -mindepth 1 -maxdepth 1 ! -name "${QT_VERSION}" -exec echo 'Cleaning Qt SDK: {}' \; -exec rm -r '{}' \; \
    && rm -rf /tmp/qt

COPY install-additional-qt-libs.sh install-linuxdeployqt.sh /tmp/qt/

# Download & unpack QtJsonSerializer
# Download & unpack linuxdeployqt
# Clean
RUN /tmp/qt/install-additional-qt-libs.sh "${QT_PATH}" "${QT_VERSION}" \
    && /tmp/qt/install-linuxdeployqt.sh \
    && rm -rf /tmp/qt

# Reconfigure locale
RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user + sudo
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
ENV HOME /home/user
