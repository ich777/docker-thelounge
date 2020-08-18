#!/bin/bash
echo "---Checking if UID: ${UID} matches user---"
usermod -u ${UID} ${USER}
echo "---Checking if GID: ${GID} matches user---"
usermod -g ${GID} ${USER}
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

echo "---Checking for optional scripts---"
if [ -f /opt/scripts/user.sh ]; then
	echo "---Found optional script, executing---"
	chmod +x /opt/scripts/user.sh
	/opt/scripts/user.sh
else
	echo "---No optional script found, continuing---"
fi

echo "---Starting...---"
LAT_V="$(curl -s https://api.github.com/repos/thelounge/thelounge/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"
CUR_V="$(thelounge --version | cut -d 'v' -f2)"
if [ -z "$LAT_V" ]; then
	echo "---Can't get latest version---"
	LAT_V="$CUR_V"
fi

echo "---Version Check---"
if [ "$CUR_V" != "$LAT_V" ]; then
	echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
	cd /tmp
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O /tmp/thelounge.deb "https://github.com/thelounge/thelounge/releases/download/v$LAT_V/thelounge_$LAT_V_all.deb" ; then
		echo "---Successfully downloaded TheLounge v$LAT_V---"
	else
		echo "---Something went wrong, can't download TheLounge v$LAT_V, putting container into sleep mode!---"
		sleep infinity
	fi
	apt-get -y install /tmp/thelounge.deb; exit 0
elif [ "$CUR_V" == "$LAT_V" ]; then
	echo "---TheLounge v$CUR_V up-to-date---"
fi

if [ ! -f ${DATA_DIR}/config.js ]; then
	cp -R /etc/thelounge/* ${DATA_DIR}/
fi

chown -R ${UID}:${GID} /opt/scripts
chown -R ${UID}:${GID} ${DATA_DIR}

term_handler() {
	ps -ef | grep node | grep -v "grep" | awk '{print $2}' | xargs kill -SIGTERM;
	tail --pid="$(pidof node)" -f 2>/dev/null
	exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM
su ${USER} -c "/opt/scripts/start-server.sh" &
killpid="$!"
while true
do
	wait $killpid
	exit 0;
done