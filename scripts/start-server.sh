#!/bin/bash
export THELOUNGE_HOME="${DATA_DIR}"
sleep infinity
echo "---Prepare Server---"
USERS="$(ls ${DATA_DIR}/users | sed 's/\.json//g')"

if grep -q "$USERNAME" <<< "$USERS"; then
	echo "---User: $USERNAME found! Nothing to do, continuing!---"
else
	echo "---Creating user: $USERNAME, Save to Log: $SAVELOG---"
	screen -d -m /opt/scripts/create-user.sh
	sleep 4
fi

chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Starting TheLounge---"
cd ${DATA_DIR}
thelounge start