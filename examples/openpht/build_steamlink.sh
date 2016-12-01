#!/bin/bash


TOP="${PWD}"
SRC="${TOP}/openpht-src"
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
	-DCOMPRESS_TEXTURES=OFF \
	-DENABLE_DUMP_SYMBOLS=ON \
	-DENABLE_AUTOUPDATE=ON \
	-DTARGET_PLATFORM=STEAMLINK \
	-DUSE_INTERNAL_FFMPEG=OFF \
	-DOPENELEC=OFF \
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
