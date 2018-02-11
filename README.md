# Jails configuration for FreeNAS

Configure your FreeNAS jails with ansible.  
All software and their dependencies are automatically
installed. Most of the configuration is taken care of as well, with the exception of settings only configurable through a web front-end (such as credentials for Usenet in SABnzbd).  
All jails have mDNS set-up, so you can access them on the internal network with `[[jailname]].local`.

The jails are:

* Reverse proxy
    * Acts as a internet facing frontend for all jail webinterfaces
    * Has a nice landing page where you can add links and parallax images for navigation
    * Automatically sets up letsencrypt
    * Authenticates you via your Google account
* [DNSCrypt Proxy](https://github.com/jedisct1/dnscrypt-proxy)
    * All jails can be configured to use this one for name resolution
    * You can set your DHCP server to tell the rest of the network to use this jail for name resolution
* [Unifi](https://unifi-sdn.ubnt.com/) server
    * Easy access to your Unifi AP configuration interface
    * Run your Unifi management software as a daemon so it can collect stats
* [SABnzbd](https://sabnzbd.org/)
* [rTorrent](https://github.com/rakshasa/rtorrent) + [ruTorrent](https://github.com/Novik/ruTorrent)
    * Contains some extra labels for ruTorrent
* [Jackett](https://github.com/Jackett/Jackett)
* [Sonarr](https://sonarr.tv/)
* [Radarr](https://radarr.video/)
* [Plex media server](https://www.plex.tv/)
    * Comes with [HelloHue](https://github.com/ledge74/HelloHue.bundle), [Trakt.tv](https://github.com/trakt/Plex-Trakt-Scrobbler), [TwitchMod](https://github.com/coryo/TwitchMod.bundle), [WebTools](https://github.com/ukdtom/WebTools.bundle/wiki), [YouTubeTV](https://github.com/kolsys/YouTubeTV.bundle) plugins
* [Grafana](https://grafana.com/) + [Telegraf](https://github.com/influxdata/telegraf) + [InfluxDB](https://www.influxdata.com/) statistics
    * Supports fetching data through IPMI from your server
    * Can get your overall network usage through SNMP from your router (only tested with Linksys LRT214)
    * Can pull data from FreeNAS' own collectd service (see `host_vars/stats@freenas.local.yaml.template`, pre-made Grafana dashboard at `roles/stats/`)
    * Pulls all S.M.A.R.T. data from your HDDs & SSDs (also has a pre-made Grafana dashboard)
* [Elasticsearch](https://www.elastic.co/products/elasticsearch) + [Kibana](https://www.elastic.co/products/kibana) [Logstash](https://www.elastic.co/products/logstash) + [Filebeat](https://www.elastic.co/products/beats/filebeat) for log aggregation
    * Most other jails are set up with filebeat to forward their logs to this jail (some parsing of logs and setup is still missing to see all logs in all jails)
    * Normalizes data from different loggers so that fields containing the same data have the same name
    * Can act as a rsyslog server for FreeNAS, Unifi, your router, and other devices on your network

# Setup

Start by creating the jails you want to create in FreeNAS.
The names must match the ones used in this project, check out `inventories/hosts.yaml`
for a list. Comment out any jail you are not interested in.  
Read the `*.template` files in `host_vars/` for instructions for the different jails
and copy them to the same directory but omit `.template` part to enable them.

# Backup

`scripts/` contains two scripts that you can use for creating versioned backups of
both your FreeNAS configuration database and the userdata of the software running in your jails.  
The jail backup script uses rsync with hardlinks two preserve diskspace.
