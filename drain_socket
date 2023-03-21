#!/bin/bash
# Retrieves last item of a socket
# Params are the file descriptor and the last read element
function drain_socket {
	fd=$1
	previous="$2"
	topmost=
	while read -t 0; do
		read -r topmost <&$1
	done <&$1
	if [[ -n "$topmost" ]]; then
		echo "$topmost"
	else 
		echo "$previous"
	fi
}
