#! /bin/sh

if [ "$#" -lt 2 ]; then
	echo "usage: $0 /path/to/libcxx /path/to/libcxxabi [opts...]"
	exit 1
fi
LIBCXX=$1
LIBCXXABI=$2
shift 2

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DLIBCXX_ENABLE_SHARED=ON -DLIBCXX_CXX_ABI=libcxxabi -DLIBCXX_LIBCXXABI_INCLUDE_PATHS=$LIBCXXABI/include $@ $LIBCXX
