#!/bin/sh

. $(dirname $0)/functions

if [ -f "${VARPATH:+$VARPATH/}./gcc.var.sh" ]; then
	. ${VARPATH:+$VARPATH/}./gcc.var.sh
else
	error "fatal: gcc.var.sh does not found"
	exit 1
fi

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
	--with-build-config=bootstrap-lto
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

# sanitize {{{
exists_or_die $SRCDIR
if [ ! -x "$SRCDIR/configure" ]; then
	error "fatal: \`$SRCDIR/configure' is not executable."
	exit 1
fi

exists_or_die $CLOOGISL
exists_or_die $PPL
# }}}

$SRCDIR/configure $CONFIGURES $USER					\
	$INTERNAL_CC CFLAGS="$DEFAULT_FLAGS $FLAGS"		\
	$INTERNAL_CXX CXXFLAGS="$DEFAULT_FLAGS $FLAGS"	\
