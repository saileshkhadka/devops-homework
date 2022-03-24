#The image should contain a webserver to serve static files that will be hosted in /opt/html.
#The container should run without superuser rights.
#Curl should also be installed in the container for testing purposes. The exposed port should be configurable.

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
	apache2 \
	curl \
	locales apt-utils && \
	locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    useradd -m ghost --shell /bin/bash -u 1000 && \
    echo "ghost:ghost" | chpasswd && \
    mkdir /opt/html /run/apache2/ /var/lock/apache2 && \
    chown -R ghost:ghost /home/ghost /opt/html /run/apache2/ /var/log/apache2/ &&\
    chown www-data:root /var/lock/apache2

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

USER apacheuser:apacheuser

COPY apache2.conf ports.conf /etc/apache2/
COPY 000-default.conf /etc/apache2/sites-available/
COPY index.html /opt/html/
COPY apache2.service /etc/systemd/system/
COPY start.sh /home/ghost/

RUN /home/ghost/start.sh

CMD service apache2 start && tail -f /dev/null
