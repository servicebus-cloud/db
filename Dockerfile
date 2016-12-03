# Zato ODB & Cluster

FROM ubuntu:16.04
MAINTAINER Andrzej Wróbel <andy@zato.io>

ENV ZATO_APP_HOME="/etc/docker-servicehub-db"\
    ZATO_HOME=/opt/zato \
    ZATO_USER=zato \
    ZATO_BINDIR=/opt/zato/current/bin

RUN ln -s -f /bin/true /usr/bin/chfn

# Install helper programs used during Zato installation
RUN apt-get update && apt-get install -y apt-transport-https \
    python-software-properties \
    software-properties-common \
    curl \
    telnet \
    sudo \
    wget

# Add the package signing key
RUN curl -s https://zato.io/repo/zato-0CBD7F72.pgp.asc | apt-key add -

# Add Zato repo to your apt
# update sources and install Zato
RUN apt-add-repository https://zato.io/repo/stable/2.0/ubuntu
RUN apt-get update && apt-get install -y zato


COPY runtime/ ${ZATO_APP_HOME}/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh
RUN chmod +x ${ZATO_APP_HOME}/db.sh
RUN chmod +x ${ZATO_APP_HOME}/cluster.sh

VOLUME ["${ZATO_HOME}"]
WORKDIR ${ZATO_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
