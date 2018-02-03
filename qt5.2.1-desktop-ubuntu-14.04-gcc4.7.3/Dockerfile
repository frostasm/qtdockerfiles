FROM ubuntu:14.04
MAINTAINER frostasm

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/5.2.1/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

# Install updates & requirements:
#  * git, openssh-client - for Drone
#  * curl, p7zip - to download & unpack Qt bundle
#  * build-essential, pkg-config, libgl1-mesa-dev - basic Qt build requirements
#  * libsm6, libice6, libxext6, libxrender1, libfontconfig1 - dependencies of Qt bundle run-file
RUN apt-get -qq update && apt-get -qq dist-upgrade && apt-get install -qq -y --no-install-recommends \
    git \
    openssh-client \
    ca-certificates \
    curl \
    p7zip \
    build-essential \
    pkg-config \
    libgl1-mesa-dev \
    libsm6 \
    libice6 \
    libxext6 \
    libxrender1 \
    libfontconfig1 \
    gcc-4.7 \
    g++-4.7 \
    && apt-get -qq clean \
    \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 10 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.7 10

# Download & unpack Qt 5.2.1 toolchains & clean
RUN mkdir -p /tmp/qt \
    && curl -Lo /tmp/qt/installer.run 'http://download.qt-project.org/official_releases/qt/5.2/5.2.1/qt-opensource-linux-x64-5.2.1.run'

RUN chmod 755 /tmp/qt/installer.run && mkdir /tmp/qt/data && /tmp/qt/installer.run --dump-binary-data -o /tmp/qt/data \
    \
    && mkdir -p $QT_PATH && cd $QT_PATH \
    && 7zr x /tmp/qt/data/qt.521.gcc_64.essentials/5.2.1gcc_64_qt5_essentials.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.521.gcc_64.addons/5.2.1gcc_64_qt5_addons.7z > /dev/null \
    && 7zr x /tmp/qt/data/qt.521.gcc_64.essentials/5.2.1icu_51_1_ubuntu_11_10_64.7z > /dev/null \
    && /tmp/qt/installer.run --runoperation QtPatch linux $QT_DESKTOP qt5 \
    \
    && rm -rf /tmp/qt

RUN locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Add group & user
RUN groupadd -r user && useradd --create-home --gid user user && echo 'user ALL=NOPASSWD: ALL' > /etc/sudoers.d/user

USER user
WORKDIR /home/user
