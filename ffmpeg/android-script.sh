#!/bin/sh

ADDI_CFLAGS="-marm"
API=19
PLATFORM=arm-linux-androideabi
# CPU=armv7-a
# CPU=armv8-a
# ARCH="arm"
# CPU="armv7-a"
NDK=/home/linuxer/apps/android-ndk-r16b
SYSROOT=$NDK/platforms/android-$API/arch-arm/
ISYSROOT=$NDK/sysroot
ASM=$ISYSROOT/usr/include/$PLATFORM
TOOLCHAIN=$NDK/toolchains/$PLATFORM-4.9/prebuilt/darwin-x86_64
# OUTPUT=./android-xxxx-v7
OUTPUT=./android-xxxx-v8
function build
{
./configure \
--prefix=$OUTPUT \
--enable-shared \
--disable-static \
--disable-doc \
--disable-ffmpeg \
--disable-ffplay \
--disable-ffprobe \
--disable-avdevice \
--disable-network \
--disable-doc \
--disable-symver \
--cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
--target-os=android \
--arch=aarch64 \
--cpu=armv8-a \
--enable-cross-compile \
--sysroot=$SYSROOT \
--extra-cflags="-I$ASM -isysroot $ISYSROOT -Os -fpic -marm" \
--extra-ldflags="-marm" \
$ADDITIONAL_CONFIGURE_FLAG
  make clean
  make j8
  make 
  make install
}

build
