#!/bin/bash

TOP="${PWD}"
SRC="${TOP}/openpht-src"
RELEASE="v1.6.2.123-e23a7eef"

#
# Download the source to OpenPHT
#
if [[ ! -d "${SRC}" ]]; then

	git clone -b "${RELEASE}" "https://github.com/RasPlex/OpenPHT.git" "${SRC}" || exit 1
	rm -f "${TOP}/.patch-applied"

else

	# clean and pull
	pushd "${SRC}"
	git clean -f
	git pull origin "${RELEASE}" 
	popd

fi


if [[ ! -f "${SRC}/configure" ]]; then

	pushd "${SRC}"
	./bootstrap || exit 1
	popd

else

	pushd "${SRC}"
	rm -f "${SRC}/configure"
	./bootstrap || exit 1
	popd

fi


# GMP from the Steam Link SDK conflicts with openpht
if [ -f "${MARVELL_ROOTFS}/usr/include/gmp.h" ]; then
	# Run this in a subshell so we don't set CC and so forth yet
	(
		source "${TOP}/../../setenv.sh"
		cd "${MARVELL_SDK_PATH}/external/gmp-6.0.0"
		if [ ! -f Makefile ]; then
			./configure $STEAMLINK_CONFIGURE_OPTS
		fi
		steamlink_make_uninstall
	)
fi

#
# Build OpenPHT

source "${TOP}/../../setenv.sh"

export CC="$CC -DEGL_API_FB"
export CXX="$CXX -DEGL_API_FB"
export CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
export LD AR AS NM STRIP RANLIB OBJDUMP
export PYTHON_VERSION PYTHON_CPPFLAGS PYTHON_LDFLAGS PYTHON_SITE_PKG PYTHON_NOVERSIONCHECK NATIVE_ROOT
#export UDEV_CFLAGS="-I${DEPS_INSTALL_PATH}/include"
export UDEV_LIBS=-ludev
#export CEC_CFLAGS="-I${DEPS_INSTALL_PATH}/include"
export CEC_LIBS=-lcec
#export LIBXML_CFLAGS="-I${DEPS_INSTALL_PATH}/include/libxml2"
e#xport PULSE_CFLAGS="-I${MARVELL_ROOTFS}/usr/include"
#export PULSE_LIBS="-lpulse -L${MARVELL_ROOTFS}/usr/lib/pulseaudio -lpulsecommon-8.0"
export PKG_CONFIG_SYSROOT_DIR="${MARVELL_ROOTFS}"
pushd "${SRC}"

# Configure
./configure $STEAMLINK_CONFIGURE_OPTS --prefix=/home/steam/apps/openpht --disable-x11 || exit 4

################STOP################
echo "=PAUSING FOR REVIEW="
sleep 20
exit 1
################STOP################

