FROM mitmproxy/mitmproxy:6.0.2

LABEL maintainer="artemkloko <artemkloko@gmail.com>"

# Because forego requires bash
RUN apk add --no-cache bash dnsmasq

# Install Forego, copied from https://dl.equinox.io/ddollar/forego/stable
ADD https://bin.equinox.io/c/ekMN3bCZFUn/forego-stable-linux-amd64.tgz ./
RUN tar xvf forego-stable-linux-amd64.tgz -C /usr/local/bin && \
    rm forego-stable-linux-amd64.tgz && \
    chmod u+x /usr/local/bin/forego

# Install docker-gen, copied from https://github.com/jwilder/nginx-proxy/blob/master/Dockerfile.alpine
ENV DOCKER_GEN_VERSION 0.7.6
RUN wget --quiet https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && tar -C /usr/local/bin -xvzf docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz \
 && rm /docker-gen-alpine-linux-amd64-$DOCKER_GEN_VERSION.tar.gz

COPY docker-entrypoint.sh /usr/local/bin/

ADD dnsmasq.tmpl /etc/dnsmasq.tmpl
ADD dnsmasq-reload /usr/local/bin/dnsmasq-reload
