FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends curl screen && \
	curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
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
	ulimit -n 2048

RUN cd /tmp && \
	wget -q -nc --show-progress --progress=bar:force:noscroll -O /tmp/thelounge.deb https://github.com/ich777/thelounge/releases/download/4.1.0/TheLounge-v4.1.0.deb && \
	apt-get -y install /tmp/thelounge.deb && \
	rm -R /tmp/thelounge.deb

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

EXPOSE 9000

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]