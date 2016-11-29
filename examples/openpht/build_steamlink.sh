#!/bin/bash
#

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
	git checkout master
	git clean -f
	git pull 
	git checkout "${RELEASE}"
	popd

fi


if [[ ! -f "${SRC}/configure" ]]; then

	pushd "${SRC}"
	./bootstrap || exit 1
	popd

fi

if [[ ! -f "${SRC}/tools/depends/configure" ]]; then

	pushd "${SRC}/tools/depends"
	./bootstrap || exit 1
	popd

fi

echo "test complete"

# All done!
#echo "Build complete!"
#echo
#echo "Put the steamlink folder onto a USB drive, insert it into your Steam Link, and cycle the power to install."
