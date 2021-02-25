#!/usr/bin/env bash

echo 'installing freetype2'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -d freetype2/.git ]
then
  git clone git://git.sv.nongnu.org/freetype/freetype2.git
fi

echo "Compiling freetype"

cd freetype2
./autogen.sh
./configure --host=${CROSS_PREFIX} --without-harfbuzz --without-png --without-zlib --without-bzip2 --prefix=${INSTALLDIR}
make clean
make install
cp objs/.libs/*.a ${INSTALLDIR}/lib
cp -r include ${INSTALLDIR}

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install freetype2, see freetype2/compile.log'
else
    echo 'install of freetype2 successful'
fi
