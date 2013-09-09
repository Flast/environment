#!/bin/sh

# XXX This script is temporary
./configure -enable-pythoninterp --enable-multibyte --disable-gui --without-x --without-gnome CFLAGS="-O4 -mtune=native -flto"
