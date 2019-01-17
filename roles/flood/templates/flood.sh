#!/bin/sh

# PROVIDE: flood
# REQUIRE: DAEMON cleanvar
# KEYWORD: shutdown

. /etc/rc.subr

flood_home=/usr/local/www/flood
flood_bin=/usr/local/www/flood/server/bin/start.js

name=flood
rcvar=flood_enable
pidfile="/var/run/${name}.pid"
logfile="/var/log/${name}.log"
command="/usr/sbin/daemon"
command_args="-o ${logfile} -P ${pidfile} -t ${name} -u flood /usr/local/bin/node ${flood_bin}"
flood_chdir=${flood_home}
argument_precmd=

load_rc_config $name
export PATH="$PATH:/usr/local/bin"
run_rc_command "$@"
