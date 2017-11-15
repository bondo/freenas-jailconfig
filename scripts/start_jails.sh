#!/usr/bin/env bash
set -e

RESTART=false
if [[ $1 == "restart" ]]; then
    RESTART=true
fi

function start_jail {
    local jail=$1
    local services=$2
    local avahi_result
    printf "\e[1;34m%s\e[0m " "$jail"
    if ! service jail onestatus "$jail" &>/dev/null; then
        service jail onestart "$jail"
        printf "\e[0;33m⬆\e[0m\n"
    else
        printf "\e[0;32m✓\e[0m\n"
    fi
    for service in $services; do
        printf "    \e[0;34m%s\e[0m " "$service"
        if $RESTART; then
            jailme "$jail" service "$service" restart &>/dev/null
            printf "\e[0;33m↻\e[0m\n"
            continue
        elif [[ $service == "avahi-daemon" ]]; then
            avahi_result=$(jailme "$jail" service "$service" start 2>&1 || true)
            if ! grep -q "Daemon already running on PID" <<<"$avahi_result"; then
                printf "\e[0;33m⬆\e[0m\n"
            else
                printf "\e[0;32m✓\e[0m\n"
            fi
            continue
        elif ! jailme "$jail" service "$service" status &>/dev/null; then
            jailme "$jail" service "$service" start &>/dev/null
            printf "\e[0;33m⬆\e[0m\n"
        else
            printf "\e[0;32m✓\e[0m\n"
        fi
    done
}

start_jail "rtorrent" "rtorrent nginx php-fpm dbus avahi-daemon"
start_jail "sabnzbd" "sabnzbd nginx dbus avahi-daemon"
start_jail "plex" "plexmediaserver filebeat dbus avahi-daemon"
start_jail "sonarr" "sonarr filebeat dbus avahi-daemon"
start_jail "jackett" "jackett dbus avahi-daemon"
start_jail "unifi" "unifi mongod filebeat dbus avahi-daemon"
start_jail "reverse-proxy" "nginx dbus avahi-daemon"
start_jail "dnscrypt-proxy" "dnscrypt-proxy unbound dbus avahi-daemon"
start_jail "stats" "grafana influxd telegraf dbus avahi-daemon"
start_jail "logs" "logstash elasticsearch kibana ipfw dbus avahi-daemon"
start_jail "kerberos-kdc" "kdc kadmind dbus avahi-daemon"
