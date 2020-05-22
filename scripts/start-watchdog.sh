#!/bin/bash
killpid="$(pidof mono)"
while true
do
	tail --pid=$killpid -f /dev/null
	kill "$(pidof mono)"
exit 0
done