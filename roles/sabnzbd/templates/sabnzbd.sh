#!/bin/sh

# PROVIDE: sabnzbd
# REQUIRE: DAEMON cleanvar
# KEYWORD: shutdown

. /etc/rc.subr

sabnzbd_home=/usr/local/libdata/sabnzbd
sabnzbd_bin=/usr/local/lib/sabnzbd/SABnzbd.py

name=sabnzbd
rcvar=sabnzbd_enable
pidfile=${sabnzbd_home}/sabnzbd.pid
command=/usr/local/bin/python
command_args="${sabnzbd_bin} --config-file ${sabnzbd_home}/sabnzbd.ini --pidfile ${pidfile} --server localhost:8080 --daemon"
sabnzbd_chdir=${sabnzbd_home}
sabnzbd_user=sabnzbd

load_rc_config $name
run_rc_command "$@"
