#!/usr/bin/env bash

echo 'installing bftpd'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -r bftpd ]; then
    git checkout -- bftpd
fi

cd bftpd
./configure --host=${CROSS_PREFIX} --enable-debug --prefix=${INSTALLDIR}
make clean
make
cp bftpd ${INSTALLDIR}/bin

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install bftpd, see bftpd/compile.log'
else
    echo 'install of bftpd successful'
fi
