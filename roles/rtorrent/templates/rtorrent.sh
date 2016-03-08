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
command_args="-n ${rtorrent_home}/rtorrent.dtach ${rtorrent_home}/set_home.sh ${rtorrent_bin}"
rtorrent_chdir=${rtorrent_home}
rtorrent_user=rtorrent

load_rc_config $name
run_rc_command "$@"
