#!/bin/sh

# android-ndk-r16b android-ndk-r17c android-ndk-r14b

export NDK_HOME=/home/linuxer/apps/android-ndk-r14b

# export PATH=$NDK_HOME:$PATH

export PREFIX=android-build
export HOST_PLATFORM=linux-x86_64
export PLATFORM=android-21
# --extra-libs=-lgcc
COMMON_OPTIONS="\
    --target-os=android \
    --enable-static \
    --disable-shared \
    --enable-small \
    --enable-cross-compile \
    --enable-neon \
    --disable-programs \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-doc \
    --disable-symver \
    --disable-asm \
    --enable-decoder=h264 \
    --enable-decoder=mpeg4 \
    --enable-decoder=mjpeg \
    --enable-decoder=png \
    --enable-decoder=vorbis \
    --enable-decoder=opus \
    --enable-decoder=flac \
    --disable-network
    "

build_all(){
    for version in armeabi-v7a arm64-v8a; do
        echo "======== > Start build $version"
        case ${version} in
        armeabi )
            ARCH="arm"
            CPU="armv5te"
            CROSS_PREFIX="$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-"
            SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm/"
            EXTRA_CFLAGS="-march=armv5te"
            EXTRA_LDFLAGS="-Wl,-L${SYSROOT}/usr/lib"
        ;;
        armeabi-v7a )
            ARCH="arm"
            CPU="armv7-a"
            CROSS_PREFIX="$NDK_HOME/toolchains/arm-linux-androideabi-4.9/prebuilt/$HOST_PLATFORM/bin/arm-linux-androideabi-"
            SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm/"
            EXTRA_CFLAGS="-march=armv7-a -mfpu=neon -mfloat-abi=softfp -mvectorize-with-neon-quad"
            EXTRA_LDFLAGS="-Wl,--fix-cortex-a8 -L${SYSROOT}/usr/lib"
        ;;
        arm64-v8a )
            ARCH="aarch64"
            CPU="armv8-a"
            CROSS_PREFIX="$NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/$HOST_PLATFORM/bin/aarch64-linux-android-"
            SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-arm64/"
            EXTRA_CFLAGS="-march=armv8-a"
            EXTRA_LDFLAGS="-Wl,-L${SYSROOT}/usr/lib"
        ;;
        x86 )
            ARCH="x86"
            CPU="i686"
            CROSS_PREFIX="$NDK_HOME/toolchains/x86-4.9/prebuilt/$HOST_PLATFORM/bin/i686-linux-android-"
            SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-x86/"
            EXTRA_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
            EXTRA_LDFLAGS="-Wl,-L${SYSROOT}/usr/lib"
        ;;
        x86_64 )
            ARCH="x86_64"
            CPU="x86_64"
            CROSS_PREFIX="$NDK_HOME/toolchains/x86_64-4.9/prebuilt/$HOST_PLATFORM/bin/x86_64-linux-android-"
            SYSROOT="$NDK_HOME/platforms/$PLATFORM/arch-x86_64/"
            EXTRA_CFLAGS="-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
            EXTRA_LDFLAGS="-Wl,-L${SYSROOT}/usr/lib"
        ;;
        esac

        echo "-------- > Start clean workspace"
        make clean

        echo "-------- > Start config makefile"
        configuration="\
            --prefix=${PREFIX} \
            --libdir=${PREFIX}/libs/${version}
            --incdir=${PREFIX}/includes/${version} \
            --pkgconfigdir=${PREFIX}/pkgconfig/${version} \
            --arch=${ARCH} \
            --cpu=${CPU} \
            --cross-prefix=${CROSS_PREFIX} \
            --sysroot=${SYSROOT} \
            --extra-ldexeflags=-pie \
            ${COMMON_OPTIONS}
            "

        echo "-------- > Start config makefile with ${configuration}"
        ./configure ${configuration}

        echo "-------- > Start make ${version} with -j8"
        make j8

        echo "-------- > Start install ${version}"
        # make install-libs
        make install
        echo "++++++++ > make and install ${version} complete."

    done
}

echo "-------- Start --------"
build_all
echo "-------- End --------"