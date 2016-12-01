#!/bin/bash

TOP="${PWD}"
SRC="${TOP}/openpht-src"
EXTERNAL_LIBS="${TOP}/external"
INSTALL_DIR="${TOP}/openpht-final"
BRANCH="steamlink-openpht-1.7"

###################################
# Download the sources
###################################

if [[ ! -d "${SRC}" ]]; then

	git clone -b "${BRANCH}" "https://github.com/ProfessorKaos64/OpenPHT.git" "${SRC}" || exit 1
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

# Need to compile jpeg/libjpeg??
# See: external/SDL2_image-2.0.1/external/jpeg-9
# Without it, JPEG_LIBRARY and JPEG_INCLUDE_DIR cannot be defined below.

rm -rf build && mkdir build
cd build
cmake -G Ninja \
	-DENABLE_PYTHON=ON \
	-DEXTERNAL_PYTHON_HOME="$MARVELL_ROOTFS/usr" \
	-DPYTHON_EXEC="$PYTHON_EXEC" \
	-DSWIG_EXECUTABLE=`which swig` \
	-DSWIG_DIR="$ROOT/$BUILD/toolchain" \
	-DCMAKE_PREFIX_PATH="$MARVELL_ROOTFS" \
	-DCMAKE_LIBRARY_PATH="$MARVELL_ROOTFS/usr/lib" \
	-DCMAKE_INCLUDE_PATH="$MARVELL_ROOTFS/usr/include;$MARVELL_ROOTFS/usr/include/python2.7" \
	-DSDLMAIN_LIBRARY="$MARVELL_ROOTFS/usr/lib" \
	-DSDL_INCLUDE_DIR="$MARVELL_ROOTFS/usr/include;$MARVELL_ROOTFS/usr/include/SDL2" \
	-DJPEG_LIBRARY="$MARVEL_ROOTFS/usr/local/Qt-5.4.1/plugins/imageformats/libqjpeg.so" \
	-DSQLITE3_LIBRARY="$MARVEL_ROOTFS/usr/local/Qt-5.4.1/plugins/imageformats/libqsqlite.so" \
	-DLZO2_INCLUDE_DIR="$EXTERNAL_LIBS/liblzo2/usr/include/lzo" \
	-DLZO2_LIBRARIES="$EXTERNAL_LIBS/liblzo2/usr/lib/aarch64-linux-gnu/liblzo2.so" \
	-DFRIBIDI_LIBRARY="$EXTERNAL_LIBS/libfribidi/usr/lib/aarch64-linux-gnu/libfribidi.so.0" \
	-DxFRIBIDI_INCLUDE_DIR="$EXTERNAL_LIBS/libfribidi/usr/include/fribidi" \
	-DCOMPRESS_TEXTURES=OFF \
	-DENABLE_DUMP_SYMBOLS=ON \
	-DENABLE_AUTOUPDATE=ON \
	-DTARGET_PLATFORM=STEAMLINK \
	-DUSE_INTERNAL_FFMPEG=ON \
	-DOPENELEC=OFF \
	-DENABLE_VDPAU=$ENABLE_VDPAU \
	-DENABLE_VAAPI=$ENABLE_VAAPI \
	-DLIRC_DEVICE=/run/lirc/lircd \
	-DCMAKE_INSTALL_PREFIX=$INSTALL_DIR \
	-DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
	..

popd

###################################
# Inststall OpenPHT
###################################

# TODO
#  DESTDIR=$INSTALL ninja install
