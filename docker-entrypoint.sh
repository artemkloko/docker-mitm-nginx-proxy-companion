#!/bin/sh
set -e

# This was copied from https://github.com/mitmproxy/mitmproxy/blob/master/release/docker/docker-entrypoint.sh

MITMPROXY_PATH="/home/mitmproxy/.mitmproxy"

if [[ "$1" = "mitmdump" || "$1" = "mitmproxy" || "$1" = "mitmweb" ]]; then
    mkdir -p "$MITMPROXY_PATH"
    chown -R mitmproxy:mitmproxy "$MITMPROXY_PATH"

    # The following part was modified to generate Procfile with the commands
    # needed to run by forego
    echo "mitmproxy: su-exec mitmproxy $@" > Procfile
    echo "dnsmasq: docker-gen -watch -only-exposed -notify \"dnsmasq-reload -u root\" /etc/dnsmasq.tmpl /etc/dnsmasq.conf" >> Procfile
    forego start -r
else
    exec "$@"
fi
