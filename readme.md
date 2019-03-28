# mitm-nginx-proxy-companion

A mashup of [mitmproxy](https://github.com/mitmproxy/mitmproxy) and [jderusse/docker-dns-gen](https://github.com/jderusse/docker-dns-gen)

---

Why:

- So you can have a dockerized replacement of [Telerik Fiddler](https://www.telerik.com/fiddler)
- So you can do "one time browser proxy plugin setup" instead of "continious editing of `/etc/hosts`" when developing web resources
- So you can mock resources selectively in a managable way
- So you can inspect intermediate pings/hops of redirects
- So you can use your production [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy)-based setup localy

---

Requirements:

- Set container dns to `127.0.0.1`
- Mount `docker.sock`
- Reverse proxy container with `mitmproxy.proxyVirtualHosts=true` label

---

Minimal example:

```
version: '3.3'

services:

  nginx-proxy-mitm:
    dns:
      - 127.0.0.1
    image: artemkloko/mitm-nginx-proxy-companion
    ports:
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  nginx-proxy:
    image: jwilder/nginx-proxy
    labels:
      - "mitmproxy.proxyVirtualHosts=true"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro

  example-one:
    environment:
      VIRTUAL_HOST: example-one.com
    image: nginx:alpine
```

- Run `docker-compose up`
- Add a proxy extension to your browser, with proxy address being `127.0.0.1:8080`
- Access `http://example-one.com`

---

Full guide:

[Mocking domain names in a maintainable and scalable way](https://medium.com/@artemkloko/mocking-domain-names-in-a-maintainable-and-scalable-way-def29e5e5e32)
