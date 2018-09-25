#!/bin/sh

sudo chmod 777 /tmp/qt/

echo  "Install lib-thrift 0.9.1"

curl -Lo /tmp/qt/libthrift-dev_0.9.1_amd64.deb http://people.apache.org/~jfarrell/thrift/0.9.1/contrib/deb/ubuntu/12.04/libthrift-dev_0.9.1_amd64.deb
curl -Lo /tmp/qt/libthrift0_0.9.1_amd64.deb http://people.apache.org/~jfarrell/thrift/0.9.1/contrib/deb/ubuntu/12.04/libthrift0_0.9.1_amd64.deb

sudo dpkg -i --ignore-depends=libqtcore4,libqt4-network /tmp/qt/libthrift0_0.9.1_amd64.deb
sudo dpkg -i --ignore-depends=libglib2.0-dev /tmp/qt/libthrift-dev_0.9.1_amd64.deb

rm -f /tmp/qt/libthrift0_0.9.1_amd64.deb
rm -f /tmp/qt/libthrift-dev_0.9.1_amd64.deb