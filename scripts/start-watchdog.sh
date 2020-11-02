#!/bin/bash
	killpid="$(pidof node)"
	while true
	do
		tail --pid=$killpid -f /dev/null
		kill "$(pidof tail)"
		exit 0
	done