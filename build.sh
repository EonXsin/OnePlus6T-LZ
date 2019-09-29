#!/bin/bash
############################################################
### Build script for HolyDragon kernel ###
############################################################

# This is the full build script used to build the official kernel zip.

# Minimum requirements to build:
# Already working build environment :P 
#
# In this script: 
# You will need to change the 'Source path to kernel tree' to match your current path to this source.
# You will need to change the 'Compile Path to out' to match your current path to this source.
# You will also need to edit the '-j32' under 'Start Compile' section and adjust that to match the amount of cores you want to use to build.
# 
# In Makefile: 
# You will need to edit the 'CROSS_COMPILE=' line to match your current path to this source.
# 
# Once those are done, you should be able to execute './build.sh' from terminal and receive a working zip.

############################################################
# Build Script Variables
############################################################ 

# Source defconfig used to build
	dc=lightningzap_defconfig

# Source Path to kernel tree
	k=/media/Dev/OnePlus/OnePlus6T-LZ

# Source Path to clean(empty) out folder
	co=$k/out

# Compile Path to out 
	o="O=/media/Dev/OnePlus/OnePlus6T-LZ/out"

# Source Path to compiled Image.gz-dtb
	i=$k/out/arch/arm64/boot/Image.gz-dtb

# Destination Path for compiled modules
	zm=$k/build/system/lib/modules

# Destination path for compiled Image.gz-dtb
	zi=$k/build/Image.gz-dtb
	
# Source path for building kernel zip
	zp=$k/build/
	
# Destination Path for uploading kernel zip
	zu=$k/upload/

# Kernel zip Name
############################################################
grep -o  'NDP-...' arch/arm64/configs/lightningzap_defconfig >temp
VER=$(<temp)
	kn=OP-6-6T-LZ-$VER.zip

############################################################
# Clear terminal
############################################################

reset

############################################################
# Cleanup
############################################################

	echo "	Cleaning up out and upload directories"
	rm -Rf out/
	#rm -Rf upload/
	echo "	Out and upload directories removed!"

	echo "	Remove old kernel image and changelog"
	rm -Rf build/Image.gz-dtb
	rm -Rf build/Changelog.txt
	echo "	Out and upload directories removed!"

############################################################
# Make out folder & upload folder
############################################################

	echo "	Making new out & upload directories"
	mkdir -p "$co"
	mkdir -p "$zu"
	echo "	Created new out & upload directories"

############################################################
# Establish defconfig
############################################################

	echo "	Establishing build environment.."
	make "$o" "$dc"

############################################################
# Start Compile
############################################################

	echo "	First pass started.."
	time make "$o" DTC_EXT=/usr/bin/dtc -j64
	echo "	First pass completed!"
	echo "	"
	echo "	Starting Second Pass.."
	time make "$o" DTC_EXT=/usr/bin/dtc -j64
	echo "	Second pass completed!"

############################################################
# Copy image.gz-dtb to /build
############################################################

	echo "	Copying kernel to zip directory"
	cp "$i" "$zi"
#	find . -name "*.ko" -exec cp {} "$zm" \;
	echo "	Copying kernel completed!"

############################################################
# Generating Changelog to /build
############################################################

	./changelog

############################################################
# Make zip and move to /upload
############################################################

	echo "	Making zip file.."
	cd "$zp"
	zip -r "$kn" *
	echo "	Moving zip to upload directory"
	mv "$kn" "$zu" 
	echo "	Completed build script!"
	echo "	Returning to start.."
	cd "$k"
