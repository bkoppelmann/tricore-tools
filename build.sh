#!/bin/bash -vx

mkdir prefix
export PREFIX=`pwd`/prefix
export PATH=$PREFIX/bin:$PATH
export TARGET=tricore

# binutils
mkdir -p package_494/binutils/build && cd package_494/binutils/build
CFLAGS=-fcommon ../configure --prefix=$PREFIX --target=$TARGET --enable-lto --with-sysroot --disable-nls --disable-werror
make -j || exit
make install
cd -

# gcc (stage1)
mkdir -p package_494/gcc/build1 && cd package_494/gcc/build1
../configure --prefix=$PREFIX --target=$TARGET --enable-lto --enable-languages=c --without-headers --with-newlib --enable-interwork --enable-multilib --disable-shared --disable-thread --disable-zlib
make all-gcc -j || exit
make install-gcc
cd -

# newlib
mkdir -p package_494/newlib//build && cd package_494/newlib/build
../configure --prefix=$PREFIX --target=$TARGET --disable-newlib-supplied-syscalls
make -j || exit
make install
cd -

# gcc (stage2)
mkdir -p package_494/gcc/build1 && cd package_494/gcc/build1
../configure --prefix=$PREFIX --target=$TARGET --enable-lto --enable-languages=c,c++ --with-newlib --enable-interwork --enable-multilib --disable-shared --disable-thread --disable-zlib
make -j || exit
make install
cd -

# gdb
mkdir -p gdb-tricore/build && cd gdb-tricore/build
../configure --prefix=$PREFIX --host=x86_64-linux-gnu --target=tricore-elf --program-prefix=tricore-elf- 
    --disable-nls --disable-itcl --disable-tk --disable-tcl --disable-winsup --disable-gdbtk --disable-libgui \
    --disable-rda --disable-sid --disable-sim --disable-newlib --disable-libgloss --disable-gas \
    --disable-ld --disable-binutils --disable-gprof --disable-source-highlight --with-system-zlib \
    --disable-werror --with-python
make -j || exit
make install
