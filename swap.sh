#!/bin/sh
if [ ! -h ./run ]; then
	if [ -d ./run ]; then
		rm -rf ./run || exit 1
		echo "$(date +'%F %T') Deleted ./run release directory."
	fi
fi

if [ -h ./run ]; then
	if [ `readlink ./run | cut -d/ -f2`  = "build-debug" ]; then
		rm ./run || exit 1
		ln -s ./build-release/bin ./run || exit 1
		echo "$(date +'%F %T') Swapped to release build."
	else
		rm ./run || exit 1
		ln -s ./build-debug/bin ./run || exit 1
		echo "$(date +'%F %T') Swapped to debug build."
	fi
else 
	if [ -e ./run ]; then
		echo "$(date +'%F %T') ./run in unknown state!"
		exit 1
	else
		ln -s ./build-debug/bin ./run || exit 1
		echo "$(date +'%F %T') Set up debug build."
	fi
fi


