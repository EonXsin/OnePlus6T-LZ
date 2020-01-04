TC_PATH=/home/thomas/Android/kernels/OnePlus6T-LZ/Toolchains
FILE=out/arch/arm64/boot/Image.gz-dtb
export ANDROID_AARCH64=$TC_PATH/linaro/bin:$TC_PATH/aarch64-linux-android-4.9/bin
export ARCH=arm64
export SUBARCH=arm64
export PATH=$TC_PATH/linaro/bin:$PATH
export PATH=$TC_PATH/aarch64-linux-android-4.9/bin:$PATH
export CC=aarch64-linux-android-
export CROSS_COMPILE=aarch64-linux-android-
reset
make O=out lightningzap_defconfig
time make O=out DTC_EXT=/usr/bin/dtc -j$(nproc --all)

if test -f "$FILE"; then
    echo "Build Complete"
else
    echo "Build Failed"
fi
