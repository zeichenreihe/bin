#!/bin/bash
#    ip.sh -- rc file for the ips
#    Copyright (C) 2020  Johannes Schmatz <johannes_schmatz@gmx.de>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

. ~/bin/bash.rc/config.sh

export ONLINE="eth"
export IP_4="$(
	wget http://checkip.dyndns.org/ -O - -o /dev/null | \
	cut -d ':' -f 2 | \
	cut -d '<' -f 1 | \
	awk '{print $1}'
)"

export IP_6="$(
	ip -6 a sh dev $IP_DEV scope global dynamic noprefixroute | \
	sed -e $'2,2!d;s/^[ ]\\+[a-z0-9]\\+ //g;
	s_/[A-Za-z0-9 ]\\+__g;s/\e\\[[0-9]\\+m//g'
)"

export IP_4_INT="$(
	ip -4 a sh $IP_DEV | \
	sed -e $'2,2!d;s/^[ ]\\+[a-z0-9]\\+ //g;
	s_/[A-Za-z0-9. ]\\+__g;s/\e\\[[0-9]\\+m//g;
	s/ [a-zA-Z0-9. ]\\+//g'
)"

export HOSTNAME_4="$(
	dig -x $IP_4 +short | \
	tr '[:upper:]' '[:lower:]' | \
	sed 's/\.$//g'
)"

export HOSTNAME_4_FB="$(
	wget https://www.freebasic.net/wiki/DocToc -O - -o /dev/null | \
	sed -e '/Your hostname/!d;s/<li>Your hostname is <tt>//gi;s/<\/tt>//gi' | \
	tr '[:upper:]' '[:lower:]'
)"

export HOSTNAME_6="$(
	dig -x $IP_6 +short | \
	tr '[:upper:]' '[:lower:]' | \
	sed 's/\.$//g'
)"

export IP_4_OLD="$(      sed -n 1p $last_hostname_file)"
export HOSTNAME_4_OLD="$(sed -n 2p $last_hostname_file)"
export IP_6_OLD="$(      sed -n 3p $last_hostname_file)"
export HOSTNAME_6_OLD="$(sed -n 4p $last_hostname_file)"

function write_hostname_to_hostname_file(){
# $1 = IPv4 addr
# $2 = IPv4 hostname
# $3 = IPv6 addr
# $4 = IPv6 hostname
	echo $1 > $last_hostname_file
	echo $2 > $last_hostname_file
	echo $3 > $last_hostname_file
	echo $4 > $last_hostname_file
}

if [[ "$HOSTNAME_4" == "$HOSTNAME_4_FB" ]]; then
	printf "${C_RED}ALERT$C_NULL IPv4 hostnames do not match!\n" 1>&2
	printf "${C_RED} --->$C_NULL dig: $C_PURPLE%s$C_NULL\n" $HOSTNAME_4 1>&2
	printf "${C_RED} --->$C_NULL FB.: $C_PURPLE%s$C_NULL\n" $HOSTNAME_4_FB 1>&2
	printf "\n" 1>&2
fi

if [[ "$HOSTNAME_4" != "$HOSTNAME_4_OLD" ]]; then
	printf "${C_BLUE}INFO:$C_NULL IPv4 update! " 1>&2
	printf "use '${C_PURPLE}update_hostname -a$C_NULL' to update\n" 1>&2

	printf "${C_BLUE} --->$C_NULL old: " 1>&2
	printf "$C_RED%-15s %s$C_NULL\n" $IP_4_OLD $HOSTNAME_4_OLD 1>&2

	printf "${C_BLUE} --->$C_NULL new: " 1>&2
	printf "$C_GREEN%-15s %s$C_NULL\n" $IP_4 $HOSTNAME_4 1>&2

	printf "\n" 1>&2
fi

if [[ "$HOSTNAME_6" != "$HOSTNAME_6_OLD" ]]; then
	printf "${C_BLUE}INFO:$C_NULL IPv6 update! " 1>&2
	printf "use '${C_PURPLE}update_hostname -a$C_NULL' to update\n" 1>&2

	printf "${C_BLUE} --->$C_NULL old: " 1>&2
	printf "$C_RED%-39s %s$C_NULL\n" $IP_6_OLD $HOSTNAME_6_OLD 1>&2

	printf "${C_BLUE} --->$C_NULL new: " 1>&2
	printf "$C_GREEN%-39s %s$C_NULL\n" $IP_6 $HOSTNAME_6 1>&2

	printf "\n" 1>&2
fi

#echo "INFO: FIREWALL: use 'mal_ips_add <ip>' to add ip" 1>&2
#echo "INFO: FIREWALL: use 'mal_ips_del <ip>' to delete ip" 1>&2
#echo "INFO: FIREWALL: use 'mal_ips_list' to list the entry" 1>&2

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
