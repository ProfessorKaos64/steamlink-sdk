# WIP for OpenPHT / PlexHT

#About

It was tested on Debian Jessie with additional packages at packages.libregeek.org:

# Scratch/WIP notes

## Current error

Trouble finding lzo lib, see: openpht-src/plex/CMakeModules/FindLzo2.cmake

```
CMake Error at plex/CMakeModules/CMakeFunctions.cmake:178 (message):
  Missing LZO2
Call Stack (most recent call first):
  plex/CMakeModules/PlatformConfigSTEAMLINK.cmake:45 (plex_find_package)
  plex/CMakeModules/CMakeConfig.cmake:82 (include)
  CMakeLists.txt:55 (include)


-- Configuring incomplete, errors occurred!
```
=======
## TODO (known)

- [ ] Backport CMake 3.1.0 (just use SteamOS Brewmaster script as template) to Debian Jessie
  - [x] build
  - [ ] local install test
  - [ ] Add to libregeek pool

## Building

* [Upstream thread regarding the embedded build](https://github.com/RasPlex/OpenPHT/issues/169)
* Use cmake to configure and make/ninja to build OpenPHT. 
* The autotools files is a leftover from the old Kodi/Xbmc code base and have/should never been used for PHT/OpenPHT.
* Take a look at [package.mk](https://github.com/RasPlex/OpenPHT-Embedded/blob/openpht-1.7/packages/mediacenter/plexht/package.mk#L223-L244) from OpenPHT-Embedded for some clues
* Need to add support for the Steam Link in the cmake files (Check commit [26c310f](https://github.com/RasPlex/OpenPHT/commit/26c310f95d5b5c4e288f2c4380be1fc0dd9dec4d), added amlogic support).

## Patches

* Everythign under the [kodi patch diff](https://github.com/ValveSoftware/steamlink-sdk/blob/master/examples/kodi/kodi.patch) should be doable.
* Most playback/rendering/audio/video parts of OpenPHT is close to Kodi Jarvis so most parts related to video/audio should be rather trivial to port, however the settings system is more close to Frodo so any code that uses the settings api will need some work.

##Building OpenPHT

Before compiling, make sure you have installed these packages (or equivalent):

``
build-essential cmake (>= 3.1.0) curl default-jre doxygen gawk git gperf
libcurl4-openssl-dev libtool ninja-build python-all-dev swig unzip zip zlib1g-dev wget
```

##Executing the build process

1. Open new terminal window, **DO NOT** `source setenv.sh` - it will break the build environment!
2. `$ cd /path/to/steamlink-sdk/examples/kodi`
3. `$ ./build_steamlink.sh`
4. Go get some coffee

This should end with `Build complete!` message and you should have `steamlink` dir in your current directory.
Copy the `steamlink` directory to a USB flash drive, insert it into the Steam Link and
power cycle the device.

##What is working:

##What is not working:

