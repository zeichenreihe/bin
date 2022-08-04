#!/bin/bash
#    .bashrc - bashrc file
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

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

. ~/bin/bash.rc/config.sh
. ~/bin/bash.rc/block_ips.sh
. ~/bin/bash.rc/alias.sh
. ~/bin/bash.rc/screenfetch.sh

# the ONLINE CHECK !!!
#if [[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]];
if true;
then
if [[ "$HOSTNAME" == "pixy" ]]; then
	. ~/bin/bash.rc/ip.sh
fi
else
	export ONLINE="not_online"
	export IP_4="127.0.0.1"
	export IP_4_INT="127.0.0.1"
	export IP_4_OLD="127.0.0.1"
	export IP_6="::1"
	export IP_6_INT="fe80::"
	export HOSTNAME_4="localhost"
	export HOSTNAME_4_FB="localhost"
	export HOSTNAME_6="localhost"
fi

# print screenfetch
(
	[[ "$(tty | head -c8)" == "/dev/tty" ]] ||
	[[ "$(tty | head -c8)" == "/dev/pts" ]]
) && [[ "$HOSTNAME" == "pixy" ]] && \
cat $screenfetch_tmp 

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
