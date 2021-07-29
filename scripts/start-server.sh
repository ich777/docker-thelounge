#!/bin/bash
CUR_V="$(thelounge --version 2>/dev/null | cut -d 'v' -f2)"
LAT_V="$(wget -qO- https://github.com/ich777/versions/raw/master/TheLounge | grep FORK | cut -d '=' -f2)"
if [ -z "$LAT_V" ]; then
		LAT_V="$(curl -s https://api.github.com/repos/thelounge/thelounge/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"
fi
if [ -z "$LAT_V" ]; then
	if [ ! -z "$CUR_V" ]; then
		echo "---Can't get latest version of TheLounge falling back to v$CUR_V---"
		LAT_V="$CUR_V"
	else
		echo "---Something went wrong, can't get latest version of TheLounge, putting container into sleep mode---"
		sleep infinity
	fi
fi

if [ -f ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz ]; then
	rm -rf ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
	echo "---TheLounge not installed, installing---"
    cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz https://github.com/ich777/thelounge/releases/download/$LAT_V/TheLounge-v$LAT_V.tar.gz ; then
    	echo "---Sucessfully downloaded TheLounge---"
    else
    	echo "---Something went wrong, can't download TheLounge, putting container in sleep mode---"
        sleep infinity
    fi
	if [ ! -d ${DATA_DIR}/bin ]; then
		mkdir ${DATA_DIR}/bin
	fi
	if [ ! -d ${DATA_DIR}/users ]; then
		mkdir ${DATA_DIR}/users
	fi
	tar -C ${DATA_DIR}/bin -xzf ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz
	rm -R ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz
elif [ "$CUR_V" != "$LAT_V" ]; then
	echo "---Version missmatch, installed v$CUR_V, downloading and installing latest v$LAT_V...---"
    cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz https://github.com/ich777/thelounge/releases/download/$LAT_V/TheLounge-v$LAT_V.tar.gz ; then
    	echo "---Sucessfully downloaded TheLounge---"
    else
    	echo "---Something went wrong, can't download TheLounge, putting container in sleep mode---"
        sleep infinity
    fi
	tar -C ${DATA_DIR}/bin -xzf ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz
	rm -R ${DATA_DIR}/TheLounge-v$LAT_V.tar.gz
elif [ "$CUR_V" == "$LAT_V" ]; then
	echo "---TheLounge v$CUR_V up-to-date---"
fi

echo "---Prepare Server---"
USERS="$(ls ${DATA_DIR}/users | sed 's/\.json//g')"

if grep -q "$USERNAME" <<< "$USERS"; then
	echo "---User: $USERNAME found! Nothing to do, continuing!---"
else
	echo "---Creating user: $USERNAME, Save to Log: $SAVELOG---"
	screen -d -m /opt/scripts/create-user.sh
	sleep 4
fi

if [ ! -f ${DATA_DIR}/config.js ]; then
	echo "---No 'config.js' found, copying default---"
	cp ${DATA_DIR}/bin/defaults/config.js ${DATA_DIR}/config.js
fi

chmod -R ${DATA_PERM} ${DATA_DIR}
export THELOUNGE_HOME="${DATA_DIR}"

echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null
echo "---Server ready---"

echo "---Starting TheLounge---"
cd ${DATA_DIR}
thelounge start 2>&1 | tee ${DATA_DIR}/masterLog.0