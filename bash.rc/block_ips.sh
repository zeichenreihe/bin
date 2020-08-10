#!/bin/bash
#    block_ips.lib.sh - lib with function for ip
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

# TODO
# iptables!!!

# function to match ips from the websrv
function mal_ips_list_matched_httpd(){
	# for Arch Linux with apache
	local file="/var/log/httpd/access_log"

	cat -v $file | \
	grep "\[`LC_ALL=C date +%d/%b/%Y:`" | \
	awk '{print $1}' | \
	sort -un | \
	grep "^\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}" | \
	grep -v "^\(127\(\.[0-9]\{1,3\}\)\{3\}\|192.168\(\.[0-9]\{1,3\}\)\
\{2\}\|10\(\.[0-9]\{0,3\}\)\{3\}\)" | \
	sed -e 's/\./ /g' | \
	sort -un | \
	sed -e 's/ /./g'
}

# function to add specific ips to mal-ips
function mal_ips_add(){
	sudo ipset add mal-ips $1
	sudo bash -c 'ipset save > /etc/ipset.conf'
	sudo iptables -I INPUT -m set --match-set mal-ips src -j DROP
}

# function to delete specific ips to mal-ips
function mal_ips_del(){
	sudo ipset del mal-ips $1
	sudo bash -c 'ipset save > /etc/ipset.conf'
	sudo iptables -I INPUT -m set --match-set mal-ips src -j DROP
}

# function to list all ips in mal-ips
function mal_ips_list(){
	grep -E "^add mal-ips [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" /etc/ipset.conf | \
		awk '{print $3}' | \
		sed 's/\./ /g' | \
		sort -n | \
		sed 's/ /./g'
}

# completion function for mal_ips_del
function _mal_ips_del(){
	COMPREPLY=($(compgen -W "`mal_ips_list`" "${COMP_WORDS[1]}"))
}
complete -F _mal_ips_del mal_ips_del

# function to add all ips from $1 to mal-ips
function mal_ips_add_file(){
	local ctr=0
	local nunber=0
	for i in `cat $1`
	do
		ctr=$((ctr+1))
		number=$((number+1))
		if sudo ipset add mal-ips $i 2>/dev/null; then
			echo -e "\e[32m$1\e[0m\e[36m:\e[0m\e[31m$ctr\e[0m\e[36m:\e[0m\e[33m$i\e[0m"
		else
			number=$((number-1))
		fi
	done
	sudo bash -c 'ipset save > /etc/ipset.conf'
	sudo iptables -I INPUT -m set --match-set mal-ips src -j DROP
	echo -e "added \e[35m$number\e[0m ips from \e[34m$1\e[0m ($ctr tries)"
}

alias mal_ips_add_matched_httpd="mal_ips_list_matched_httpd | mal_ips_add_file /dev/stdin"

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
