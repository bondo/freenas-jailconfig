#!/usr/bin/env bash

function backup {
    local date
    local version
    local hostname
    date=$(date +%Y%m%d%H%M%S)
    version=$(cat /etc/version)
    hostname=$(hostname -s)
    cp \
        /data/freenas-v1.db \
        "/mnt/media/backup/FreeNAS/$hostname-$version-$date.db"
}

backup
