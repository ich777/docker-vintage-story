#!/bin/bash
DL_URL="$(curl -s http://api.vintagestory.at/${VS_CHANNEL}.json | jq '.' | grep server | grep linux | grep local | head -1 | cut -d '"' -f4)"
LAT_V=${DL_URL##*_}
CUR_V="$(find ${DATA_DIR} -name installed-* | cut -d '-' -f2-)"
if [ -z $LAT_V ]; then
  if [ -z $CUR_V ]; then
	  echo "---Something went wrong, can't get latest version and found no local version, putting server into sleep mode!---"
	  sleep infinity    
  fi
  echo "---Can't get lateste version but found local version, continuing with local version..."
  LAT_V=$CUR_V
fi

echo "---Version Check---"
if [ -z "$CUR_V" ]; then
	echo "---Vintage Story not found, downloading...---"
	cd ${DATA_DIR}
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/vintagestory-$LAT_V "$DL_URL" ; then
		echo "---Successfully downloaded Vintage Story v${LAT_V%.tar.gz}---"
	else
		echo "---Can't download Vintage Story v${LAT_V%.tar.gz}, putting server into sleep mode!---"
		sleep infinity
	fi
	tar -xvf ${DATA_DIR}/vintagestory-$LAT_V
	rm ${DATA_DIR}/vintagestory-$LAT_V
	touch ${DATA_DIR}/installed-${LAT_V%.tar.gz}
elif [ "${LAT_V%.tar.gz}" != "$CUR_V" ]; then
	echo "---Newer version found, installing!---"
	rm ${DATA_DIR}/installed-$CUR_V
	cd ${DATA_DIR}
	find . -maxdepth 1 -not -name 'data' -print0 | xargs -0 -I {} rm -R {} 2&>/dev/null
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/vintagestory-$LAT_V "$DL_URL" ; then
		echo "---Successfully downloaded Vintage Story v${LAT_V%.tar.gz}---"
	else
		echo "---Can't download Vintage Story v${LAT_V%.tar.gz}, putting server into sleep mode!---"
		sleep infinity
	fi
	tar -xvf ${DATA_DIR}/vintagestory-$LAT_V
	rm ${DATA_DIR}/vintagestory-$LAT_V
	touch ${DATA_DIR}/installed-${LAT_V%.tar.gz}
elif [ "${LAT_V%.tar.gz}" == "$CUR_V" ]; then
	echo "---Vintage Story version up-to-date---"
else
	echo "---Something went wrong, putting server in sleep mode---"
	sleep infinity
fi

echo "---Preparing Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Checking for old logs---"
find ${DATA_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null

echo "---Starting Server---"
cd ${DATA_DIR}
if [ -f "${DATA_DIR}/VintagestoryServer.exe" ]; then
  screen -S VintageStory -L -Logfile ${DATA_DIR}/masterLog.0 -d -m mono VintagestoryServer.exe --dataPath ${DATA_DIR}/data ${GAME_PARAMS}
  sleep 2
  screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
  tail -f ${DATA_DIR}/masterLog.0
elif [ -f "${DATA_DIR}/VintagestoryServer" ]; then
  screen -S VintageStory -L -Logfile ${DATA_DIR}/masterLog.0 -d -m ${DATA_DIR}/VintagestoryServer --dataPath ${DATA_DIR}/data ${GAME_PARAMS}
  sleep 2
  screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
  tail -f ${DATA_DIR}/masterLog.0
else
  echo "Can't find game executable, putting container into sleep mode!"
  sleep infinity
fi