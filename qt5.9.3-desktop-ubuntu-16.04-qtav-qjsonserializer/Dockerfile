FROM rabits/qt:5.9-desktop
MAINTAINER frostasm

ENV DEBIAN_FRONTEND noninteractive

ARG QT_VERSION=5.9.3

ENV QT_PATH /opt/Qt

RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        libavutil-dev \
        libavcodec-dev \
        libavformat-dev \
        libavfilter-dev \
        libgstreamer-plugins-base1.0-dev && \
    sudo apt-get -qq clean


COPY install-libs.sh /tmp/qt/

RUN cd /tmp/qt/ && \
    sudo /tmp/qt/install-libs.sh $QT_PATH $QT_VERSION left && \
    sudo rm -rf /tmp/qt