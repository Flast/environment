#! /bin/sh

PREFIX=$1
shift 1

if [ ! -e "$PREFIX" ]; then
	echo "'$PREFIX' does not exists"
	exit 1
elif [ ! -d "$PREFIX" ]; then
	echo "'$PREFIX' is not directory"
	exit 2
fi

PATH=$PREFIX/bin:$PATH
LD_LIBRARY_PATH=$PREFIX/lib:$LD_LIBRARY_PATH
LIBRARY_PATH=$PREFIX/lib:$LIBRARY_PATH
if [ -d "$PREFIX/lib32" ]; then
	LD_LIBRARY_PATH=$PREFIX/lib32:$LD_LIBRARY_PATH
	LIBRARY_PATH=$PREFIX/lib32:$LIBRARY_PATH
fi
if [ -d "$PREFIX/lib64" ]; then
	LD_LIBRARY_PATH=$PREFIX/lib64:$LD_LIBRARY_PATH
	LIBRARY_PATH=$PREFIX/lib64:$LIBRARY_PATH
fi
CPATH=$PREFIX/include:$CPATH
C_INCLUDE_PATH=$PREFIX/include:$C_INCLUDE_PATH
CPLUS_INCLUDE_PATH=$PREFIX/include:$CPLUS_INCLUDE_PATH

export PATH
export LD_LIBRARY_PATH
export LIBRARY_PATH
export CPATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH
