#!/usr/bin/env bash

set -e

# uncomment to disable the detectionOn/Off/Tracking script execution, instead rely on MQTT
#NO_MOTION_SYSTEM_CALLS="-UMOTION_SYSTEM_CALLS"

. ../setCompilePath.sh

export CFLAGS="-mmusl -I${INSTALLDIR}/include"
export CPPFLAGS="-mmusl -I${INSTALLDIR}/include"
export CXXFLAGS="-mmusl -I${INSTALLDIR}/include"
export LDFLAGS="-mmusl -L${INSTALLDIR}/lib"

export PKG_CONFIG_PATH=$ROOTPATH/_install/lib/pkgconfig
export LIBRARY_PATH=$ROOTPATH/_install/lib
export CFLAGS="${CFLAGS} -DLOGURU_STACKTRACES=0 -I../v4l2rtspserver-tools -I../_install/include/freetype2 -I../../_install/include/"
export CPPFLAGS="${CPPFLAGS} -DLOGURU_STACKTRACES=0 -I../v4l2rtspserver-tools -I../_install/include/freetype2 -I../../_install/include/ -std=c++11"
export CXXFLAGS="${CPPFLAGS}"
#export LDFLAGS="${LDFLAGS} -L${LIBRARY_PATH} -lrt -lstdc++ -lpthread -ldl -lmosquitto -lssl -ltls -lcrypto"
export LDFLAGS="${LDFLAGS} -L${LIBRARY_PATH}"
rm -f CMakeCache.txt
rm -fr CMakeFiles
cmake -DCMAKE_TOOLCHAIN_FILE="./dafang.toolchain"  -DCMAKE_INSTALL_PREFIX=./_install --debug-output
make VERBOSE=1 -j4 install

err=$?
if [ $err != 0 ]; then
    exit $err
else
    ${CROSS_COMPILE}strip -s _install/bin/*
    cp v4l2rtspserver-master.ini _install/bin/

    echo '-------------------------------------------------------'
    echo 'all good, run ./deploy.sh <ip> to deploy to your camera'
    exit 0
fi
