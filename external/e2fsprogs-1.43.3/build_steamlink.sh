#!/bin/bash

source ../../setenv_external.sh

./configure $STEAMLINK_CONFIGURE_OPTS

steamlink_make_clean
steamlink_make 
steamlink_make_install
