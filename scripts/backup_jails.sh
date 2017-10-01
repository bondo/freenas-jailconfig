#!/usr/bin/env bash

date=$(date +%Y%m%d%H%M%S)

function cleanup {
    local source=$1
    local destination=$2
    printf "Failed backing up %s\n" "$source" >&2
    if [[ -n $destination ]]; then
        rm -rf "$destination"
    fi
    return 1
}

function backup {
    local source=${1%/}
    local destination=${2%/}
    local start
    local end
    start=$(date +%s)
    # shellcheck disable=SC2064
    trap "cleanup $source" EXIT
    if [[ ! -e $destination ]]; then
        mkdir "$destination"
        mkdir "$destination/current"
    fi
    mkdir "$destination/$date"
    # shellcheck disable=SC2064
    trap "cleanup $source $destination/$date" EXIT
    rsync \
        --archive \
        --link-dest="$destination/current" \
        --log-file="$destination/$date/rsync.log" \
        "$source/." \
        "$destination/$date"
    rm -rf "$destination/current"
    ln -s "$date" "$destination/current"
    trap EXIT
    printf "Successfully backed up %s\n" "$source"
    end=$(date +%s)
    printf "Backup took %d seconds\n" "$((end-start))" >> "$destination/$date/rsync.log"
}

jails=/mnt/jails
backup=/mnt/media/backup/jails

(set -e; backup $jails/unifi/usr/local/share/java/unifi/data/backup $backup/unifi)
(set -e; backup $jails/rtorrent/usr/local/libdata/rtorrent $backup/rtorrent)
(set -e; backup $jails/sabnzbd/usr/local/libdata/sabnzbd $backup/sabnzbd)
(set -e; backup $jails/jackett/var/db/jackett $backup/jackett)
(set -e; backup $jails/sonarr/usr/local/sonarr $backup/sonarr)
(set -e; backup $jails/radarr/usr/local/radarr $backup/radarr)
(set -e; backup $jails/plex/usr/local/plexdata $backup/plex)
