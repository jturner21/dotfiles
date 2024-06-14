#!/bin/sh

# Set format options
FORMAT_UP='%{T0}'              # Switch to font-1
FORMAT_DOWN='%{T0}%{F#e0e1dd}' # Switch to font-1 and set color

# Count the number of tun adapters, e.g. tun0, tun1, etc
TUNTAPS=$(ip -j tuntap list | jq -r '.[].ifname' | grep -c '^tun')

if [ "$TUNTAPS" != "0" ]; then
	# This filters the JSON output from ip to show "name ip.ip.ip.ip" for each adapter
	MESSAGE_UP=$(
		ip -4 -j addr show |
			jq '[ .[] | select( .ifname | startswith("tun")) | [ .ifname, .addr_info[0].local ]  ]' |
			jq '[ .[] | join(" ") ]' |
			jq -r 'join(", ")'
	)
	echo "$FORMAT_UP$MESSAGE_UP"
else
	MESSAGE_DOWN='VPN down'
	echo "$FORMAT_DOWN$MESSAGE_DOWN"
fi
