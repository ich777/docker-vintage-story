#!/bin/bash
if [ -f "${DATA_DIR}/VintagestoryServer.exe" ]; then
  killpid="$(pidof mono)"
elif [ -f "${DATA_DIR}/VintagestoryServer" ]; then
  killpid="$(pidof VintagestoryServer)"
fi

while true
do
	tail --pid=$killpid -f /dev/null
	kill "$(pidof tail)"
exit 0
done