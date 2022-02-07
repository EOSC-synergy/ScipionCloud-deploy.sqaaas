#!/bin/bash
set -xe

S_USER=scipionuser
S_USER_HOME=/home/${S_USER}

if [ -z "$ROOT_PASS" ] || [ -z "$USER_PASS" ] || [ -z "$USE_DISPLAY" ]; then
	echo "please run the container with these variables: \nROOT_PASS\nUSER_PASS\nUSE_DISPLAY\n"
	exit 1
fi

echo -e "$ROOT_PASS\n$ROOT_PASS" | passwd root
echo -e "$USER_PASS\n$USER_PASS" | passwd $S_USER

chown munge.munge /etc/munge/munge.key

service munge start

mkdir -p ${S_USER_HOME}/ScipionUserData/data
chown -R $S_USER:$S_USER $S ${S_USER_HOME}/ScipionUserData
chown -R $S_USER:$S_USER $S_USER_HOME/.config
chown $S_USER:$S_USER $S_USER_HOME/scipion3/config/hosts.conf

su -c $S_USER_HOME/docker-entrypoint.sh $S_USER

