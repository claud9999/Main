#!/usr/bin/env bash

echo 'installing dropbear'

(

set -e # fail out if any step fails

. ../../setCompilePath.sh

export CFLAGS="${CFLAGS} -DFAKE_ROOT"
if [ ! -d dropbear ]
then
    git clone https://github.com/mkj/dropbear
fi
cp *.h dropbear
cd dropbear
echo '#define DEFAULT_PATH "/usr/bin:/bin:/system/bin:/system/sdcard/bin"' >> localoptions.h

autoconf; autoheader
./configure --host=${CROSS_PREFIX} --disable-zlib
make clean
make PROGRAMS="dropbear dbclient scp dropbearkey dropbearconvert" MULTI=1 SCPPROGRESS=1

cp dropbearmulti ${INSTALLDIR}/bin

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install dropbear, see dropbear/compile.log'
else
    echo 'install of dropbear successful'
fi
