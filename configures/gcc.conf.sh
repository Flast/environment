#!/bin/bash

# -*- user defined options -*-
PROG_SUFFIX="-"				# set valid program suffix
PREFIX="/path/to/prefix"	# set valid prefix
SRCDIR="/path/to/source"

#CC="gcc"
#CXX="g++"
#FLAGS=""
LANGS="c,c++"

#WITHCLOOGISL="true"
CLOOGISL="/path/to/cloog"
#WITHPPL="true"
PPL="/path/to/ppl"

USER="
"

# -*- implicit options -*- {{{

ENABLES="
	--enable-silent-rules
	--enable-threads
	--enable-lto
	--enable-plugin
	--enable-clocale=gnu
	--enable-checking=release
	--enable-__cxa_atexit
	--enable-languages=$LANGS,lto
	--enable-linker-build-id
	--enable-libstdcxx-pch
	--enable-libstdcxx-time=yes
"

DISABLES="
	--disable-bootstrap
	--disable-nls
	--disable-werror
"

WITH="
	--with-system-zlib
	--with-tune=native
	--with-gnu-ld
	--with-pic
	--with-sysroot=/
	--with-build-config=\"lto O3\"
"

WITHOUT="
	--without-included-gettext
"

OTHERS="
	${PREFIX:+--prefix=$PREFIX}
	${PROG_SUFFIX:+--program-suffix=$PROG_SUFFIX}
"

OPTIONALS="
	${WITHCLOOGISL:+"
	--enable-cloog-backend=isl
	--with-cloog${CLOOGISL:+=$CLOOGISL}
	"}
	${WITHPPL:+--with-ppl${PPL:+=$PPL}}
"

CONFIGURES="$ENABLES $DISABLES $WITH $WITHOUT $OTHERS $OPTIONALS"

if [ "$CC" != "" ]; then
	INTERNAL_CC="CC=$CC"
fi

if [ "$CXX" != "" ]; then
	INTERNAL_CXX="CXX=$CXX"
fi

DEFAULT_FLAGS="-O4 -mtune=native"
# }}}

# utilities {{{
error() {
	echo "$*" >&2
}

exists_or_die() {
	if [ "$1" ] && [ ! -d "$1" ]; then
		echo "fatal: The directory \`$1' does not exist."
		exit 1
	fi
}
# }}}

# sanitize {{{
exists_or_die $SRCDIR
if [ ! -x "$SRCDIR/configure" ]; then
	error "fatal: \`$SRCDIR/configure' is not executable."
	exit 1
fi

exists_or_die $CLOOGISL
exists_or_die $PPL
# }}}

echo \
$SRCDIR/configure $CONFIGURES $USER					\
	$INTERNAL_CC CFLAGS="$DEFAULT_FLAGS $FLAGS"		\
	$INTERNAL_CXX CXXFLAGS="$DEFAULT_FLAGS $FLAGS"	\
