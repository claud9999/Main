#!/usr/bin/env bash

echo 'installing dosfstools'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

if [ ! -d dosfstools/.git ]
then
  git clone https://github.com/dosfstools/dosfstools
fi


cd dosfstools
./autogen.sh
./configure --host=${CROSS_PREFIX} --prefix=${INSTALLDIR} --enable-compat-symlinks
make
make install
cp src/fatlabel src/fsck.fat src/mkfs.fat ${INSTALLDIR}/bin 

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install dosfstools, see dosfstools/compile.log'
else
    echo 'install of dosfstools successful'
fi
