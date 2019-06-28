make clean

cmake -DCMAKE_TOOLCHAIN_FILE=build-opencv-armeabi.cmake -DCMAKE_BUILD_TYPE=Debug -DDLIB_USE_CUDA=0  ../

make -j 8
