#!/usr/bin/env bash

echo 'installing mosquitto'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

export LDFLAGS="${LDFLAGS} -lrt -lssl -ltls -lcrypto -lpthread"

if [ ! -d mosquitto/.git ]
then
  git clone https://github.com/eclipse/mosquitto.git
  patch mosquitto/config.mk config.diff 
fi

cd mosquitto
make

cp client/mosquitto_sub ${INSTALLDIR}/bin/mosquitto_sub.bin
cp client/mosquitto_pub ${INSTALLDIR}/bin/mosquitto_pub.bin
cp src/mosquitto ${INSTALLDIR}/bin/mosquitto.bin
cp lib/libmosquitto.so.1 ${INSTALLDIR}/lib
if [ ! -r ${INSTALLDIR}/lib/libmosquitto.so ]; then
    ln -s ${INSTALLDIR}/lib/libmosquitto.so.1 ${INSTALLDIR}/lib/libmosquitto.so
fi
cp include/* ${INSTALLDIR}/include

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install mosquitto, see mosquitto/compile.log'
else
    echo 'install of mosquitto successful'
fi
