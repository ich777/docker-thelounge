FROM ich777/debian-baseimage

LABEL org.opencontainers.image.authors="admin@minenet.at"
LABEL org.opencontainers.image.source="https://github.com/ich777/docker-thelounge"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl screen && \
	curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
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