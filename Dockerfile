FROM debian:stable-slim

ENV PDNS_CONF_DIR /usr/local/etc/powerdns

RUN \
  apt-get update -y && \
  env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl gnupg2 ca-certificates && \
  echo "deb [arch=amd64] http://repo.powerdns.com/debian $(. /etc/os-release; echo \"$VERSION_CODENAME\")-auth-master main" > /etc/apt/sources.list.d/pdns.list && \
  echo "Package: pdns-*\nPin: origin repo.powerdns.com\nPin-Priority: 600" > /etc/apt/preferences.d/pdns && \
  curl -fsSL 'https://repo.powerdns.com/CBC8B383-pub.asc' | apt-key add - && \
  apt-get update -y && \
  env DEBIAN_FRONTEND=noninteractive apt-get install -y pdns-server && \
  apt-get purge -y curl && \
  find /var/lib/apt/lists -mindepth 1 -delete

CMD pdns_server --config-dir="$PDNS_CONF_DIR"