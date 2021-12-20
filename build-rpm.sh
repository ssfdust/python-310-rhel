#!/bin/sh
yum install -y rpm-build
sed -i "1a exit 0" /usr/lib/rpm/brp-python-bytecompile
cd /root
rpmbuild -ba "$INSTALLPATH"/python-3.10.spec
