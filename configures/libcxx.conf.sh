#! /bin/sh

. $(dirname $0)/functions

PREFIX="/path/to/prefix"
SRCDIR="$1"
LIBCXXABI="$2"

#CC="clang"
#CXX="clang++"
#FLAGS=""

# -*- implicit options -*- {{{

BUILD="
	-DBUILD_SHARED_LIBS=ON
	-DCMAKE_BUILD_TYPE=Release
	-DDEFAULT_SYSROOT=/
	-DLIBCXX_ENABLE_SHARED=ON
	${PREFIX:+-DCMAKE_INSTALL_PREFIX=$PREFIX}
"

ABI="
	-DLIBCXX_CXX_ABI=libcxxabi
	-DLIBCXX_LIBCXXABI_INCLUDE_PATHS=$LIBCXXABI/include
"

# }}}

# sanitize {{{
exists_or_die $SRCDIR
exists_or_die $LIBCXXABI

if [ "$#" -lt 2 ]; then
	echo "usage: $0 /path/to/libcxx /path/to/libcxxabi [opts...]"
	exit 1
fi

shift 2

# }}}

cmake $BUILD $ABI						\
	${CC:+-DCMAKE_C_COMPILER=$CC}		\
	${CXX:+-DCMAKE_CXX_COMPILER=$CXX}	\
	$@ $SRCDIR							\
