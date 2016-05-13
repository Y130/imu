#!/bin/sh
# nginx binary name, optionally its path.
nginx='nginx'
# Path for nginx temp files. If changed, update 'ngx/temp_paths.conf'.
root='./.ngx'
# This should be set to the error log used in 'ngx.conf'.
log="$root/error.log"
dir=`pwd`

mkdir -p $root/client_body >/dev/null 2>&1
mkdir -p $root/fastcgi >/dev/null 2>&1
mkdir -p $root/proxy >/dev/null 2>&1
mkdir -p $root/scgi >/dev/null 2>&1
mkdir -p $root/uwsgi >/dev/null 2>&1

case "$1" in
	"start")
		$nginx -p "$dir" -c "$dir/ngx.conf" >$log 2>&1
		echo "$(date +'%F %T') nginx started."
		;;
	"stop")
		$nginx -p "$dir" -c "$dir/ngx.conf" -s stop >$log 2>&1
		echo "$(date +'%F %T') nginx stopped."
		;;
	"quit")
		$nginx -p "$dir" -c "$dir/ngx.conf" -s quit >$log 2>&1
		echo "$(date +'%F %T') nginx quit."
		;;
	"reload")
		$nginx -p "$dir" -c "$dir/ngx.conf" -s reload >$log 2>&1
		echo "$(date +'%F %T') nginx reloaded."
		;;
	"reopen")
		$nginx -p "$dir" -c "$dir/ngx.conf" -s reopen >$log 2>&1
		echo "$(date +'%F %T') nginx reopened."
		;;
	*)
		echo "usage: ./web.sh (start|stop|quit|reload|reopen)"
		exit 1
		;;
esac
