#!/bin/sh

# PROVIDE: jackett
# REQUIRE: LOGIN
# KEYWORD: shutdown

. /etc/rc.subr

name=jackett
rcvar=jackett_enable

load_rc_config $name

: ${jackett_enable="NO"}
: ${jackett_user:="jackett"}
: ${jackett_data_dir:="/var/db/jackett"}

procname=/usr/local/bin/mono
command=/usr/sbin/daemon
command_args="-f /usr/local/bin/mono /usr/local/www/jackett/JackettConsole.exe -d ${jackett_data_dir}"

start_precmd="export XDG_CONFIG_HOME=${jackett_data_dir}"

run_rc_command "$@"
