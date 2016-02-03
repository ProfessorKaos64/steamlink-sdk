#!/bin/bash
#

source ../../setenv.sh

export TOP="${PWD}"
export DESTDIR="${PWD}/steamlink/apps/retroarch"
export SRC="${PWD}/retroarch-src"

# Create intall dirs

for dir in ${DESTDIR} ${SRC} ; do
	rm -rf "${dir}"
	mkdir -p "${dir}"
done

# obtain source code
git clone https://github.com/libretro/RetroArch.git "${SRC}" || exit 1

# Enter source dir
cd "${SRC}"

# Configure
# See example: https://www.raspberrypi.org/forums/viewtopic.php?t=56070
# See similar example project: steamlink-sdk/external/util-linux-2.25/build_steamlink.sh
# The last line is the default options exported by setenv.sh

./configure --disable-vg --disable-opengl --disable-gles --disable-fbo --disable-egl \
--enable-dispmanx --disable-x11 --disable-sdl2 --enable-floathard --disable-ffmpeg \
--disable-netplay --enable-udev --disable-sdl --disable-pulse --disable-oss \
--disable-freetype --disable-7zip --disable-libxml2  --prefix=/usr || exit 2

# Optimizations possible?
# For example 'CFLAGS = -mfpu=vfp -mfloat-abi=hard -march=armv6zk -mtune=arm1176jzf-s'

# Build files in build dir
steamlink_make_clean
make V=1 || exit 2
steamlink_make_install

#for dir in dir1 dir2 dir3; do
#    mkdir -p "${DESTDIR}/${dir}"
#    echo "Placeholder for ${dir} directory" >"${DESTDIR}/${dir}/dir.txt"
#done

# Strip the binary
# This then may not be needed? 'cp retroarch "${DESTDIR}"

armv7a-cros-linux-gnueabi-strip "${DESTDIR}/retroarch"

# Create the table of contents and icon
# TODO: make bas64 icon for retroarch if this works
# http://b64.io/

# Add the toc
cat >"${DESTDIR}/toc.txt" <<__EOF__
name=RetroArch
icon=retroarch.jpg
run=retroarch
__EOF__

base64 -d >"${DESTDIR}/retroarch.jpg" <<__EOF__
/9j/4AAQSkZJRgABAQAAAQABAAD//gA7Q1JFQVRPUjogZ2QtanBlZyB2MS4wICh1c2luZyBJSkcg
SlBFRyB2NjIpLCBxdWFsaXR5ID0gODUK/9sAQwAFAwQEBAMFBAQEBQUFBgcMCAcHBwcPCwsJDBEP
EhIRDxERExYcFxMUGhURERghGBodHR8fHxMXIiQiHiQcHh8e/9sAQwEFBQUHBgcOCAgOHhQRFB4e
Hh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4e/8AAEQgAgACA
AwEiAAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMF
BQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkq
NDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqi
o6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/E
AB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMR
BAUhMQYSQVEHYXETIjKBCBRCkaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVG
R0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKz
tLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMRAD8A
+MqKKKACiiigAooooAKKKKACiiigAooooAKKKKACiiigAorT8K6BrPinxFZeHvD2nTajql9L5Vvb
xD5nPUkk8KoAJLEgKASSACa9/f8AY3+I6SGJ/FXgRXHVTqFwCPw8igD5tr6H8LfB/wCE/h74eaH4
o+M/jnWNIvfEVqt5p2l6XEjSRwEttkZgsu4OhiYcJtyVOT08++MnwX8efCmWGTxNYQS6bcSeVban
ZS+bbTPsDFckBkOCQA6qW2OV3BSa7n9tHVbzxFq/gDxTfpFHdaz4Psr2ZIQRGskgLsEBJIXLcZJO
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
KACiiigAooooAKKKKAP/2Q==
__EOF__

# All done!
echo "Build complete!"
echo
echo "Put the steamlink folder onto a USB drive, insert it into your Steam Link, and cycle the power to install."
