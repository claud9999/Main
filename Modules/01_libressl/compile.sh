#!/bin/bash

echo 'installing libressl'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -d portable/.git ]; then
    git clone https://github.com/libressl-portable/portable.git
    cd portable
#    git checkout OPENBSD_6_6
    sed -i 's/program_invocation_short_name/"?"/g' crypto/compat/getprogname_linux.c
    cd ..
fi

cd portable
./autogen.sh
./configure --prefix=${INSTALLDIR} --host=${CROSS_PREFIX} --with-pic
make -j4
make install

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install libressl, see libressl/compile.log'
else
    echo 'install of libressl successful'
fi
