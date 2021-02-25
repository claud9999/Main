#!/usr/bin/env bash

export CROSS_PREFIX='mipsel-linux-musl'

ROOTPATH=$(git rev-parse --show-toplevel)
export MUSL=${ROOTPATH}/${CROSS_PREFIX}-cross
if [ ! -d ${MUSL} ]; then
    cd ${ROOTPATH}
    curl -s https://musl.cc/${CROSS_PREFIX}-cross.tgz | tar -xvzf -
fi

export CC=${MUSL}/bin/${CROSS_PREFIX}-gcc
export LD=${MUSL}/bin/${CROSS_PREFIX}-ld
export CCLD=${MUSL}/bin/${CROSS_PREFIX}-ld
export CXX=${MUSL}/bin/${CROSS_PREFIX}-g++
export CXXLD=${MUSL}/bin/${CROSS_PREFIX}-ld
export CPP=${MUSL}/bin/${CROSS_PREFIX}-cpp
export CXXCPP=${MUSL}/bin/${CROSS_PREFIX}-cpp
export AR=${MUSL}/bin/${CROSS_PREFIX}-ar
export STRIP=${MUSL}/bin/${CROSS_PREFIX}-strip
export INSTALLDIR=${ROOTPATH}/_install

export CFLAGS="-mmusl -O3 -I${INSTALLDIR}/include -fPIC"
export CPPFLAGS="-mmusl -O3 -I${INSTALLDIR}/include -fPIC"
export CXXFLAGS="-mmusl -O3 -I${INSTALLDIR}/include -fPIC"
export LDFLAGS="-mmusl -O3 -L${INSTALLDIR}/lib -fPIC"
