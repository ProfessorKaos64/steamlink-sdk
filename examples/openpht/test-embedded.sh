#!/bin/bash
#

TOP="${PWD}"
SRC="${TOP}/openpht-src-embedded"

#
# Download the source to OpenPHT
#
if [ ! -d "${SRC}" ]; then
	git clone -b "v1.7.1.137-b604995c-aml" "https://github.com/RasPlex/OpenPHT-Embedded" "${SRC}" || exit 1
	rm -f "${TOP}/.patch-applied"
	
else

	# clean and pull
	pushd "${SRC}
	git clean
	git pull
	popd
fi


if [ ! -f "${SRC}/configure" ]; then
	pushd "${SRC}"
	./bootstrap || exit 1
	popd
fi

if [ ! -f "${SRC}/tools/depends/configure" ]; then
	pushd "${SRC}/tools/depends"
	./bootstrap || exit 1
	popd
fi

./configure

# All done!
echo "Build complete!"
echo
echo "Put the steamlink folder onto a USB drive, insert it into your Steam Link, and cycle the power to install."
