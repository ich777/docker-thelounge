FROM ich777/novnc-baseimage:latest_armv7

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl screen && \
	curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
	apt-get -y install --no-install-recommends nodejs && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR=/thelounge
ENV USERNAME="admin"
ENV USERPASSWORD="password"
ENV SAVELOG="yes"
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV DATA_PERM=770
ENV USER="thelounge"

RUN mkdir $DATA_DIR && \
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ln -s /thelounge/bin/index.js /usr/bin/thelounge && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

EXPOSE 9000

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]