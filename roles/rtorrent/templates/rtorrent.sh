#!/bin/sh

# PROVIDE: rtorrent
# REQUIRE: DAEMON cleanvar
# KEYWORD: shutdown

. /etc/rc.subr

rtorrent_home=/usr/local/libdata/rtorrent
rtorrent_bin=/usr/local/bin/rtorrent

name=rtorrent
rcvar=rtorrent_enable
procname=${rtorrent_bin}
command=/usr/local/bin/dtach
dtach_dir="/var/run/rtorrent/"
command_args="-n ${dtach_dir}/rtorrent.dtach ${rtorrent_home}/set_home.sh ${rtorrent_bin}"
rtorrent_chdir=${rtorrent_home}
rtorrent_user=rtorrent
argument_precmd=

mkdir $dtach_dir
chown $rtorrent_user $dtach_dir
load_rc_config $name
run_rc_command "$@"
