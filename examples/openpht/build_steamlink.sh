#!/bin/bash



TOP="${PWD}"
SRC="${TOP}/openpht-src"
RELEASE="v1.6.2.123-e23a7eef"

###################################
# Download the sources
###################################

if [[ ! -d "${SRC}" ]]; then

	git clone -b "${RELEASE}" "https://github.com/RasPlex/OpenPHT.git" "${SRC}" || exit 1
	rm -f "${TOP}/.patch-applied"

fi

###################################
# Build OpenPHT
###################################

source "${TOP}/../../setenv.sh"

pushd "${SRC}"

## TODO ##
# Fix up where various vars were set in OpenPHT embedded.
# Determine fully what is needed dep-wise

export PYTHON_EXEC="$SYSROOT_PREFIX/usr/bin/python2.7"
cmake -G ninja -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
	-DENABLE_PYTHON=ON \
	-DEXTERNAL_PYTHON_HOME="$SYSROOT_PREFIX/usr" \
	-DPYTHON_EXEC="$PYTHON_EXEC" \
	-DSWIG_EXECUTABLE=`which swig` \
	-DSWIG_DIR="$ROOT/$BUILD/toolchain" \
	-DCMAKE_PREFIX_PATH="$SYSROOT_PREFIX" \
	-DCMAKE_LIBRARY_PATH="$SYSROOT_PREFIX/usr/lib" \
	-DCMAKE_INCLUDE_PATH="$SYSROOT_PREFIX/usr/include;$SYSROOT_PREFIX/usr/include/python2.7" \
	-DCOMPRESS_TEXTURES=OFF \
	-DENABLE_DUMP_SYMBOLS=ON \
	-DENABLE_AUTOUPDATE=ON \
	-DTARGET_PLATFORM=LINUX \
	-DUSE_INTERNAL_FFMPEG=OFF \
	-DOPENELEC=ON \
	-DENABLE_VDPAU=$ENABLE_VDPAU \
	-DENABLE_VAAPI=$ENABLE_VAAPI \
	-DLIRC_DEVICE=/run/lirc/lircd \
	-DCMAKE_INSTALL_PREFIX=/usr/lib/plexht \
	-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	..

popd

###################################
# Inststall OpenPHT
###################################

# TODO
#  DESTDIR=$INSTALL ninja install
