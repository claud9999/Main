#!/usr/bin/env bash

echo 'installing pcre'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -d pcre-8.43 ]
then
    wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz
    tar xvfz pcre-8.43.tar.gz
    rm pcre-8.43.tar.gz
fi

cd pcre-8.43
./configure --host=${CROSS_PREFIX} --prefix=${INSTALLDIR}
make clean
make
make install

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install pcre, see pcre/compile.log'
else
    echo 'install of pcre successful'
fi
