#!/bin/sh
if [ "$1" = "--release" ]; then
	if [ -d ./build-release/bin ]; then
		[ -L ./run ] && rm ./run
		[ -d ./run ] && rm -rf ./run
		mkdir ./run
		mv ./build-release/bin/* ./run/
		echo "$(date +'%F %T') Placed binaries in 'run/'."
	fi
	for i in build-*/*; do
		file=`echo $i |cut -d'/' -f2`
		if [ ! $file = "tup.config" ]; then
			rm -rf $i >/dev/null 2>&1
		fi
	done
	echo "$(date +'%F %T') Deleted build artifacts."
	rm -rf .ngx/ >/dev/null 2>&1 && echo "$(date +'%F %T') Deleted nginx artifacts."
else
	for i in build-*/*; do
		file=`echo $i |cut -d'/' -f2`
		if [ ! $file = "tup.config" ]; then
			rm -rf $i >/dev/null 2>&1
		fi
	done
	echo "$(date +'%F %T') Deleted build artifacts."
	rm -rf .ngx/ >/dev/null 2>&1 && echo "$(date +'%F %T') Deleted nginx artifacts."
fi
