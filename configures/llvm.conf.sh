#! /bin/sh

. $(dirname $0)/functions

PREFIX="/path/to/prefix"
SRCDIR="$1"

#CC="clang"
#CXX="clang++"
#FLAGS=""

# -*- implicit options -*- {{{

BUILD="
	-DBUILD_SHARED_LIBS=ON
	-DCMAKE_BUILD_TYPE=Release
	-DDEFAULT_SYSROOT=/
	-DLLVM_ENABLE_THREADS=ON
	${PREFIX:+-DCMAKE_INSTALL_PREFIX=$PREFIX}
"

# }}}

# sanitize {{{
exists_or_die $SRCDIR

if [ "$#" -e 1 ]; then
	echo "usage: $0 /path/to/llvm [opts...]"
	exit 1
fi

shift 1

# }}}

cmake $BUILD							\
	${CC:+-DCMAKE_C_COMPILER=$CC}		\
	${CXX:+-DCMAKE_CXX_COMPILER=$CXX}	\
	$@ $SRCDIR							\
