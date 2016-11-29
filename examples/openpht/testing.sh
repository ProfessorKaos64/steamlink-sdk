#!/bin/bash
#

source "${TOP}/../../setenv.sh"

TOP="${PWD}"
SRC="${TOP}/openpht-src-embedded"

#
# Download the source to OpenPHT
#
if [ ! -d "${SRC}" ]; then
	git clone -b "v1.7.1.137-b604995c-aml" "https://github.com/RasPlex/OpenPHT-Embedded" "${SRC}" || exit 1
	rm -f "${TOP}/.patch-applied"
	
fi

# Enter source dir, or ensure we are already in the correct directory
cd "${SRC}" || exit 1

./boostrap
mkdir build && cd build
cmake \
	-DCMAKE_BUILD_TYPE=Release \
	
	..


# All done!
echo "Build complete!"
echo
echo "Put the steamlink folder onto a USB drive, insert it into your Steam Link, and cycle the power to install."
