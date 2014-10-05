#!/bin/sh

. $(dirname $0)/functions

if [ -f "${VARPATH:+$VARPATH/}./gcc.var.sh" ]; then
	. ${VARPATH:+$VARPATH/}./gcc.var.sh
else
	error "fatal: gcc.var.sh does not found"
	exit 1
fi

# -*- implicit options -*-

OPTIMIZATION="
	--with-tune=native
	--with-gnu-ld
	${BUILDCONFIG:+--with-build-config=$BUILDCONFIG}
	--enable-checking=release
	--enable-libstdcxx-pch
	--enable-__cxa_atexit
"

FEATURES="
	--enable-threads
	--enable-lto
	--enable-plugin
"

BUILD="
	--enable-clocale=gnu
	--enable-linker-build-id
	--disable-nls
	--disable-werror
	--with-pic
"

MISCS="
	--enable-languages=$LANGS,lto
	--enable-silent-rules
	${SYSROOT:+--with-sysroot=$SYSROOT}
	${PREFIX:+--prefix=$PREFIX}
	${PROG_SUFFIX:+--program-suffix=$PROG_SUFFIX}
"

LIBS="
	--with-system-zlib
	--without-included-gettext
	${ISL:+--with-ls=$ISL}
	${CLOOGISL:+"
	--enable-cloog-backend=isl
	--with-cloog=$CLOOGISL
	"}
	${PPL:+--with-ppl=$PPL}
"

# sanitize
exists_or_die $SRCDIR
if [[ ! -x "$SRCDIR/configure" ]]; then
	error "fatal: \`$SRCDIR/configure' is not executable."
	exit 1
fi

exists_or_die $ISL
exists_or_die $CLOOGISL
exists_or_die $PPL

$SRCDIR/configure $OPTIMIZATION $FEATURES $MISCS	\
	$BUILD $LIBS									\
	$USER											\
	${CC:+CC="$CC"} ${CXX:+CXX="$CXX"}				\
	CFLAGS="$CFLAGS $CFAMILY_FLAGS"			\
	CXXFLAGS="$CXXFLAGS $CFAMILY_FLAGS"		\
	${LDFLAGS:+LDFLAGS="$LDFLAGS"}					\

