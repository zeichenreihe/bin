#!/bin/bash
#    config.sh -- bash config
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

#
# NAME and EMAIL
#
NAME="Johannes Schmatz"
EMAIL="johannes_schmatz@gmx.de"

#
# EDITOR
#
export EDITOR="/usr/bin/vim"
export GIT_EDITOR="$EDITOR"

#
# PATH
#
export PATH="/home/$USER/bin:$PATH"

#
# your PS1
#
export PS1="$C_NULL"'[\u@\h \W]\$ '

# VIM internal shell
[[ -n $VIM ]]&&PS1="vim $PS1"

# EMOJI (unncomment to use)
#. ~/bin/bash.rc/emoji.sh
#[[ "$DISPLAY" != "" ]]&&PS1='[\u@\h \W]$(RANDOM_EMOJI $?)\$ '

#
# '/tmp' results in 'cd /tmp'
#
shopt -s autocd

#
# DNS TYPES to see with dns
#
export DNS_TYPES="a aaaa txt ns mx soa ptr"

#
# HISTORY
#
export HISTFILESIZE=10000
export HISTSIZE=10000

#
# FILE where the OLD hostname is stored
#
last_hostname_file=~/bin/tmp/last_hostname

#
# FILE where SCREENFETCH is CACHED
#
screenfetch_tmp=~/bin/tmp/screenfetch_tmp

#
# FILE where the CONTACTS are to inform on IP CHANGE
#
hostname_contacts_file=~/.mutt/contacts.txt

#
# DEFAULT NETWORK DEVICE setting
#
case $HOSTNAME in #(((
	"pixy")
		export IP_DEV="enp0s25"
	;;
	"birne")
		export IP_DEV="eth0"
	;;
	"kirsche")
		export IP_DEV="wlan1"
	;;
esac

#
# COLORs
C_NULL=$'\e[0m'
C_BOLD=$'\e[1m'
C_UNDERLINE=$'\e[4m'
C_BLINK=$'\e[5m'
C_REVERSE=$'\e[7m'
# foreground ...........v-- with 1 (C_BOLD)
C_BLACK=$'\e[30m';	C_DGRAY=$'\e[1;30m'
C_RED=$'\e[31m';	C_LRED=$'\e[1;31m'
C_GREEN=$'\e[32m';	C_LGREEN=$'\e[1;32m'
C_BROWN=$'\e[33m';	C_YELLOW=$'\e[1;33m'
C_BLUE=$'\e[34m';	C_LBLUE=$'\e[1;34m'
C_PURPLE=$'\e[35m';	C_LPURPLE=$'\e[1;35m'
C_CYAN=$'\e[36m';	C_LCYAN=$'\e[1;36m'
C_LGRAY=$'\e[37m';	C_WHITE=$'\e[1;37m'
# background ...........v-- with 1 (C_BOLD)
C_B_BLACK=$'\e[40m';	C_B_DGRAY=$'\e[1;40m'
C_B_RED=$'\e[41m';	C_B_LRED=$'\e[1;41m'
C_B_GREEN=$'\e[42m';	C_B_LGREEN=$'\e[1;42m'
C_B_BROWN=$'\e[43m';	C_B_YELLOW=$'\e[1;43m'
C_B_BLUE=$'\e[44m';	C_B_LBLUE=$'\e[1;44m'
C_B_PURPLE=$'\e[45m';	C_B_LPURPLE=$'\e[1;45m'
C_B_CYAN=$'\e[46m';	C_B_LCYAN=$'\e[1;46m'
C_B_LGRAY=$'\e[47m';	C_B_WHITE=$'\e[1;47m'
#]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
#just close all brackets :-D

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
