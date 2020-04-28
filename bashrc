#!/bin/bash
#    .bashrc - bashrc file
#    Copyright (C) 2020  Johannes Schmatz
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

# for root
#	#!/bin/bash
#
#	#loadkeys de
#
#	alias ls="ls --color"
#	alias ll="ls -la"

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && exit 0

export PATH="/home/johannes/bin:$PATH"
export EDITOR="/usr/bin/vim"
export GIT_EDITOR="/usr/bin/vim"
export HISTFILESIZE="1000"

export DNS_TYPES="a aaaa txt ns mx soa"
export MUSIC_PLAYER="mplayer"
export MUSIC_DIR="music"

export ONLINE="no"
export ONLINE_SAVE="no"
export ONLINE_IP=" 0.0.0.0"
[[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]]&&export ONLINE="yes"
[[ "$(systemctl status sshd.service | grep running | wc -l)" == "0" ]]&&export ONLINE_SAVE="yes"
[[ "$ONLINE" == "yes" ]]&&export ONLINE_IP="$(wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d '<' -f1)"

function dns(){
	local a b
	for a in "$@"
	do
		for b in $DNS_TYPES
		do
			dig $b +noall +answer $a
		done
	done
}
function ip_outside(){
	[[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]]&&wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d '<' -f1 
}
function online_status(){
	export ONLINE="no"
	export ONLINE_SAVE="no"
	export ONLINE_IP=" 0.0.0.0"
	[[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]]&&export ONLINE="yes"
	[[ "$(systemctl status sshd.service | grep running | wc -l)" == "0" ]]&&export ONLINE_SAVE="yes"
	[[ "$ONLINE" == "yes" ]]&&export ONLINE_IP="$(wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d '<' -f1)"

	echo "online:           $ONLINE"
	echo "online save:      $ONLINE_SAVE"
	echo "online ip:       $ONLINE_IP"
}
function unixtime(){
	while sleep 1;
	do
		clear
		date
		date +%s
	done
}
function unixtimex(){
	while sleep 1;
	do
		clear
		date
		date +%s
		sudo bash -c 'date +%s > /dev/console'
	done
}
function hist(){
	eval history | awk '{print $2}' | awk 'BEGIN {FS="|"}{print $1}' | sort | uniq -c | sort -rn | head -$1 | nl | less
}
function weather(){
	[[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]]&&curl wttr.in/$1
}
function weather_short(){
	weather $1 2>/dev/null | head -7 | tail -5
}
function random_number(){
	head -c1 /dev/urandom | od -An -vtu1 | tr -d ' '
}
function qrcode(){
	[[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]]&&echo "$@" | curl -F-=\<- qrenco.de 
}
function prime_check(){
	openssl prime $@ | sed -e "s/[()isrmeot]//g"  | awk '{print $3 " " $2}'
}

alias ll="ls -la"
alias ls="ls --color"

alias brexit="exit"
alias vimbash="vim ~/.bashrc && . ~/.bashrc"

alias tm="tmux"

alias am="alsamixer"
alias cls=clear
alias o="less -r"

alias libreoffice="libreoffice --nologo"
alias startx="startx 2>/dev/null >/dev/null"
alias moon='weather "moon?lang=de"'
#alias music_dir_queen="cd ~/$MUSIC_DIR/queen/"
alias music_dir_queen="ls $MUSIC_DIR/queen ; echo -n 'Enter ALBUM: ' ; read ALBUM; export ALBUM ; cd $MUSIC_DIR/queen/*\$ALBUM*/"
alias sudo_edit="sudo EDITOR=vim visudo"
alias wlan='ip a sh wlp2s2 | grep inet | grep -v inet6 | awk "{print \$2}"'
alias minicom="sudo minicom"

alias BOFH="telnet towel.blinkenlights.nl 666 2>/dev/null | tail -3 | head -2 "
alias L8="echo 'LAYER 8 PROBLEM'"

[[ "$(tty | head -c8)" == "/dev/tty" ]] && bin/screenfetch

#sudo loadkeys de-latin1
#setterm -foreground green -store -clear

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
