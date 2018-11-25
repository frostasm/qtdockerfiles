FROM frostasm/qt:qt5.11-desktop
MAINTAINER frostasm <frostasm@gmail.com>

ARG QT_VERSION=5.11.2

ENV DEBIAN_FRONTEND noninteractive
ENV QT_PATH /opt/Qt
ENV QT_DESKTOP $QT_PATH/${QT_VERSION}/gcc_64
ENV PATH $QT_DESKTOP/bin:$PATH

RUN sudo apt update \
    && sudo apt install -y --no-install-recommends \
    libpoppler-qt5-dev \
    libopencv-dev \
    libzbar-dev \
    libkf5solid-dev \
    libkf5archive-dev \
    && sudo apt-get -qq clean


COPY install-additional-qt-libs.sh /tmp/qt/

RUN /tmp/qt/install-additional-qt-libs.sh \
    && sudo rm -rf /tmp/qt
