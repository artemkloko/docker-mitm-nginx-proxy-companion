# mitm-nginx-proxy-companion

A mashup of [jderusse/docker-dns-gen](https://github.com/jderusse/docker-dns-gen) and [mitmproxy](https://github.com/mitmproxy/mitmproxy)

---

Why:
- So you can have a dockerized replacement of [Telerik Fiddler](https://www.telerik.com/fiddler)
- So you can do "one time browser proxy plugin setup" instead of "continious editing of `/etc/hosts`" when developing web resources
- So you can mock resources selectively in a managable way
- So you can inspect intermediate pings/hops of redirects
- So you can use your production `jwilder/nginx-proxy`-based setup localy

---

Requirements:
- Set container dns to `127.0.0.1`
- Mount `docker.sock`
- Reverse proxy container with "mitmproxy.proxyVirtualHosts=true" label

---

Minimal example:
```
version: '3.3'
services:
  nginx-proxy:
    image: jwilder/nginx-proxy
    labels:
      - "mitmproxy.proxyVirtualHosts=true"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
  nginx-proxy-mitm:
    dns:
      - 127.0.0.1
    image: artemkloko/mitm-nginx-proxy-companion
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
```
