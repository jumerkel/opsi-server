# OPSI Dockerfile
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

FROM debian:stretch

MAINTAINER Julian Merkel <julian.merkel@kit.edu>

ENV DEBIAN_FRONTEND noninteractive

ENV OPSI_USER="$OPSI_USER"
ENV OPSI_PASSWORD="$OPSI_PASSWORD"
ENV OPSI_BACKEND="$OPSI_BACKEND"
ENV OPSI_DB_NAME="$OPSI_DB_NAME"
ENV OPSI_DB_OPSI_USER="$OPSI_DB_OPSI_USER"
ENV OPSI_DB_OPSI_PASSWORD="$OPSI_DB_OPSI_PASSWORD"
ENV OPSI_DB_ROOT_PASSWORD="$OPSI_DB_ROOT_PASSWORD"


RUN apt-get update -qq

RUN apt-get install -y -qq hostname apt-utils iputils-ping openssl net-tools openssh-client vim nano

RUN apt-get install -y -qq wget lsof host python-mechanize p7zip-full cabextract openbsd-inetd pigz cpio

RUN apt-get install -y -qq samba samba-common smbclient cifs-utils

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales

RUN sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=de_DE.UTF-8
    
ENV LANG de_DE.UTF-8 

RUN echo "deb http://download.opensuse.org/repositories/home:/uibmz:/opsi:/4.1:/stable/Debian_9.0/ /" > /etc/apt/sources.list.d/opsi.list

RUN wget -nv https://download.opensuse.org/repositories/home:uibmz:opsi:4.1:stable/Debian_9.0/Release.key -O Release.key 

RUN apt-key add - < Release.key

RUN apt-get update -qq

RUN apt-get -y remove tftpd

RUN apt-get install -y -qq opsi-tftpd-hpa opsi-server opsi-configed opsi-windows-support

RUN apt-get clean

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/var/lib/opsi/", "/etc/opsi/", "/tftpboot/"]

COPY ./scripts/entrypoint.sh /usr/local/bin/

COPY ./scripts/systemctl.py /usr/local/bin/

COPY ./scripts/opsiconfd /etc/init.d/

COPY ./scripts/opsi-setup /usr/bin/

RUN chmod +x /etc/init.d/opsiconfd

RUN chmod +x /usr/bin/opsi-setup

EXPOSE 139/tcp 445/tcp 4447/tcp 69/udp 137/udp 138/udp 69/udp

ENTRYPOINT ["/bin/bash"]
