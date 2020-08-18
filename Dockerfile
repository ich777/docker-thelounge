FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
	apt-get -y install --no-install-recommends nodejs && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/thelounge
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="thelounge"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

RUN cd /tmp && \
	wget -O /tmp/thelounge.deb https://github.com/thelounge/thelounge/releases/download/v4.1.0/thelounge_4.1.0_all.deb && \
	apt-get -y install /tmp/thelounge.deb; exit 0 && \
	rm -R /tmp/thelounge.deb

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

EXPOSE 9000

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]