#!/usr/bin/env bash

echo 'installing opus'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

export CFLAGS="${CFLAGS} -DDEBUG_TRACE -DFAKE_ROOT "

if [ ! -d opus-1.3.1 ]
then
	wget https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
	tar xf opus-1.3.1.tar.gz
	rm opus-1.3.1.tar.gz
fi
cd opus-1.3.1/
./configure --host=${CROSS_PREFIX} --prefix=${INSTALLDIR}
make
cp --preserve=links -L .libs/lib* ${INSTALLDIR}/lib 
cp include/* ${INSTALLDIR}/include

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install opus, see opus/compile.log'
else
    echo 'install of opus successful'
fi
