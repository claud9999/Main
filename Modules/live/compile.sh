#!/usr/bin/env bash

echo 'installing live555'

(

set -e # fail out if any step fails

unset  TOOLCHAIN
. ../../setCompilePath.sh

P=`pwd`

INCLUDES="${INCLUDES} -I${P}/live555/BasicUsageEnvironment/include -I${P}/live555/groupsock/include -I${P}/live555/liveMedia/include -I${P}/live555/UsageEnvironment/include"
COMPILE_OPTS="${INCLUDES} -DSOCKLEN_T=socklen_t -D_LARGEFILE_SOURCE=1 -D_FILE_OFFSET_BITS=64 -DXLOCALE_NOT_USED=1 -DLOCALE_NOT_USED -DBS1 -fPIC -DALLOW_RTSP_SERVER_PORT_REUSE=1"

if [ ! -d live555 ]; then
    git checkout -- live555
fi

cd live555

cat << EOF > config.dafang 
libliveMedia_LIB_SUFFIX=so

libBasicUsageEnvironment_VERSION_CURRENT=1
libBasicUsageEnvironment_VERSION_REVISION=0
libBasicUsageEnvironment_VERSION_AGE=0
libBasicUsageEnvironment_LIB_SUFFIX=so

libUsageEnvironment_VERSION_CURRENT=4
libUsageEnvironment_VERSION_REVISION=0
libUsageEnvironment_VERSION_AGE=1
libUsageEnvironment_LIB_SUFFIX=so

libgroupsock_VERSION_CURRENT=9
libgroupsock_VERSION_REVISION=1
libgroupsock_VERSION_AGE=1
libgroupsock_LIB_SUFFIX=so

#####

LIBSSL = ${INSTALLDIR}/lib/libssl.a ${INSTALLDIR}/lib/libcrypto.a ${INSTALLDIR}/lib/libtls.a  -pthread 
OBJ = o

C = c
C_COMPILER = ${CC}
CFLAGS = ${CFLAGS} ${COMPILE_OPTS}
C_FLAGS = ${CFLAGS} ${COMPILE_OPTS}
CPP = cpp
CPLUSPLUS_COMPILER = ${CXX}
CPLUSPLUS_FLAGS = ${CXXFLAGS} -fexceptions ${COMPILE_OPTS}
OBJ = o
LINK = ${CXX} -o
LINK_OPTS = -L. ${LDFLAGS}
CONSOLE_LINK_OPTS = ${LINK_OPTS}
LIBRARY_LINK = ${CC} -o

SHORT_LIB_SUFFIX = so
LIB_SUFFIX = \$(SHORT_LIB_SUFFIX)
LIBRARY_LINK_OPTS = \$(LIBSSL) -shared -Wl,-soname,\$(NAME).\$(SHORT_LIB_SUFFIX) \$(LDFLAGS)
LIBS_FOR_CONSOLE_APPLICATION = ${CXXLIBS} \$(LIBSSL) 
LIBS_FOR_GUI_APPLICATION = \$(LIBS_FOR_CONSOLE_APPLICATION) \$(LIBSSL) 
EXE =
EOF

./genMakefiles dafang
make clean
make
cp BasicUsageEnvironment/libBasicUsageEnvironment.so ${INSTALLDIR}/lib
cp UsageEnvironment/libUsageEnvironment.so ${INSTALLDIR}/lib
cp groupsock/libgroupsock.so ${INSTALLDIR}/lib
cp liveMedia/libliveMedia.so ${INSTALLDIR}/lib
cd ..

) > compile.log 2>&1

errcode=$?

if [ $errcode -ne 0 ]; then
    echo 'failed to install live555, see live555/compile.log'
else
    echo 'install of live555 successful'
fi
