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

### CONFIGURATION ###
export EDITOR="/usr/bin/vim"
export HISTFILESIZE="1000"

### ROOT BASHRC ###
#	#!/bin/bash
#
#	#loadkeys de
#
#	alias ls="ls --color"
#	alias ll="ls -la"

### ORGINAL ####
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '
#-- END ORGINAL ---

function SET_PS1(){
	PS1='[\u@\h \W]\$ '
	### EMOJI ###
	. ~/bin/emoji.rc.sh
	[[ "$DISPLAY" != "" ]]&&PS1='[\u@\h \W]$(RANDOM_EMOJI $?)\$ '
	#-- END EMOJI ---
}


### DEFAULT CONFIGURATION ###
export PATH="/home/$USER/bin:$PATH"
export GIT_EDITOR="$EDITOR"
export HISTFILESIZE="10000"

### OWNER INFORMATION ###
export EMAIL="johannes_schmatz@gmx.de"
export NAME="Johannes Schmatz"

### ONLINE SECTION ###
# the script needs to know what is the end of your hostname
export HOSTNAME_PROVIDER_END=".t-ipconnect.de"

# the other person to wich will be the email send
HOSTNAME_OTHER_NAME="DENNIS"
HOSTNAME_OTHER_SUB="hostname"
HOSTNAME_OTHER_EMAIL="dennis.emanuel.hentschel@gmail.com"

# the default network adapter
if [[ $HOSTNAME == "pixy" ]]; then
	export ONLINE_DEFAULT_DEV="enp0s25"
else
	export ONLINE_DEFAULT_DEV="eth0"
fi

function online_update(){ # get the HOSTNAME etc.
	#if [[ "$(wget http://42.org -O - -o /dev/null|head -1)" == "<HTML><HEAD>" ]];
	if true;
	then
		export ONLINE="yes"
		export ONLINE_IP="$(
			wget http://checkip.dyndns.org/ -O - -o /dev/null | \
			cut -d ':' -f 2 | \
			cut -d '<' -f 1 | \
			awk '{print $1}'
		)"

		export ONLINE_INT_IP="$(
			ip a sh $ONLINE_DEFAULT_DEV | \
			grep "inet" | \
			grep -v "inet6" | \
			sed 's/\// /' | \
			awk '{print $2}'
		)"

		export ONLINE_HOSTNAME="$(
			dig -x $ONLINE_IP +noall +answer | \
			awk '{print $5}' | \
			tr '[:upper:]' '[:lower:]' | \
			sed "s/$HOSTNAME_PROVIDER_END\./$HOSTNAME_PROVIDER_END/"
		)"

		export ONLINE_HOSTNAME_FB="$(
			curl "https://www.freebasic.net/wiki/wikka.php?wakka=FBWiki" 2>/dev/null | \
			head -129 | \
			tail -1 | \
			cut -b 26- | \
			cut -b -29 | \
			tr '[:upper:]' '[:lower:]'
		)"

		export ONLINE_HOSTNAME_OLD="$(cat ~/bin/ip_addr)"

		if [[ "$ONLINE_HOSTNAME" != $ONLINE_HOSTNAME_FB ]];
		then
			echo "ALERT: The hostname returned from Freebasic ($ONLINE_HOSTNAME_FB)" 1>&2
			echo "ALERT: is not the same as from dig ($ONLINE_HOSTNAME)." 1>&2
		fi

		if [[ "$ONLINE_HOSTNAME_OLD" != "$ONLINE_HOSTNAME" ]]; then
			echo "INFO: Online Hostname has changed from $HOSTNAME_OLD to $ONLINE_HOSTNAME," 1>&2
			echo "INFO: use 'certificate_update' to update" 1>&2
			echo "INFO: to send the new hostname and IP to $HOSTNAME_OTHER_NAME use 'hostname_update'" 1>&2
			echo "INFO: to create a new page /tmp/schul-cloud/* for schul-cloud.org use 'schul-cloud_update'" 1>&2
			alias certificate_update="sudo /home/$USER/bin/cert.sh $ONLINE_HOSTNAME_OLD $ONLINE_HOSTNAME"
			alias hostname_update="mutt -s \"$HOSTNAME_OTHER_SUB\" $HOSTNAME_OTHER_EMAIL <<< \"\$(echo -e \"$ONLINE_IP\n$ONLINE_HOSTNAME\")\""
			function schul-cloud_update(){
				[[ -d /tmp/schul-cloud/ ]]||mkdir /tmp/schul-cloud
				sed "s/127.0.0.1/$ONLINE_HOSTNAME/g" < ~/http/schul-cloud.html > /tmp/schul-cloud/Lustiges_YT_Video.html
			}
		fi

		if [[ "$(systemctl status sshd.service | grep running | wc -l)" == "0" ]];
		then
			export ONLINE_SAVE="yes"
		else
			echo "INFO: sshd is running, use 'make sshd_stop' to stop it" 1>&2
			echo "INFO: FIREWALL: use 'mal_ips_add <ip>' to add ip" 1>&2
			echo "INFO: FIREWALL: use 'mal_ips_del <ip>' to delete ip" 1>&2
			echo "INFO: FIREWALL: use 'mal_ips_list' to list the entry" 1>&2
		fi

		# that function returns the weather of $1, $2 ... in short, if there is only one in long
		function weather(){ 
			if [[ "$#" == 1 ]]; then
				curl wttr.in/$1
			else
				local a
				for a in "$@"
				do
					echo $a;
					curl wttr.in/$a 2> /dev/null | \
						head -7 | \
						tail -5
				done
			fi
		}

		# function that prints a qrcode of it's arguments
		function qrcode(){
			curl -F-=\<- qrenco.de <<< "$@"
		}
	else
		export ONLINE="no"
		export ONLINE_SAVE="yes"
		export ONLINE_IP="127.0.0.1"
		export ONLINE_INT_IP="127.0.0.1"
		export ONLINE_HOSTNAME="localhost"
		export ONLINE_HOSTNAME_FB="localhost"
		export ONLINE_HOSTNAME_OLD="localhost"

		alias weather="echo \"You are not ONLINE!\""
		alias qrcode="echo \"You are not ONLINE!\""
	fi
}
# run it to see the hostname etc.
online_update

# all dns types for dns
export DNS_TYPES="a aaaa txt ns mx soa ptr"

# get the dns records of $@
# x.x.x.x.ip -> reverse lookup
function dns(){
	local a b
	for a in "$@"
	do
		for b in $DNS_TYPES
		do
			if [[ "$(sed 's/[0-9]//g' <<< "$a")" == "....ip" ]];
			then
				dig $b +noall +answer -x $(sed 's/.ip//' <<< "$a")
			else
				dig $b +noall +answer $a
			fi
		done
	done
}

# get the dns records of x.x.x.x x=0..255
function dns_xxxx(){
	for i in {1..255}
	do
		dns $i.$i.$i.$i.ip
	done
}

## IPSET SECTION ##
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
#- END IPSET SECTION --
#-- END ONLINE SECTION ---

### ALIAS + FUNCTION SECTION ###
# 1 char
alias o="less -r"
alias q="exit"

# 2 char
alias ls="ls --color"
alias ll="ls -la"
alias tm="tmux"
alias am="alsamixer"
alias L8="echo 'LAYER 8 PROBLEM'"

# 3 char
alias cls=clear

# 4 char
alias moon='weather "moon?lang=de"'
alias grep="grep --color=auto"
alias BOFH="telnet towel.blinkenlights.nl 666 2>/dev/null | tail -3 | head -2 "
alias motd="~/hacks/motd/new.sh"
function hist(){ # print the $1 most often used commands, 0=10 most used
	eval history | \
	sed 's/[^ \t]\+//; s/#/# /g; s/=.*/= /; s/;/ /g' | \
	awk '{print $1}' | \
	sort | \
	uniq -c | \
	sort -rn | \
	head -$1 | \
	nl | \
	less
#	eval history | \
#	awk '{print $2}' | \
#	awk 'BEGIN {FS="|"}{print $1}' | \
#	sort | \
#	uniq -c | \
#	sort -rn | \
#	head -$1 | \
#	nl | \
#	less
}

# 5 char
alias image="fbi"

# 6 char
alias bashrc=". ~/.bashrc"
alias brexit="cd; sudo clear ; screenfetch ; make update poweroff && exit"
alias startx="startx 2>/dev/null >/dev/null"

# 7 char
alias vimbash="vim ~/.bashrc && . ~/.bashrc"
alias minicom="sudo minicom -D /dev/ttyS0"
function rainbow(){
	for i in {21..51..6} {50..46} {82..226..36} {220..196..6} {197..201} {165..21..36}
	do
		echo -en "\e[48;5;${i}m\e[38;5;${i}m#\e[0m"
	done
	echo
}

# 9 char
alias sudo_edit="sudo EDITOR=vim visudo"
function read_code(){ # read code $1=to line, 0=all; $2-number of lines, 0=all;$@ - files to cat
	if [[ "$1" == "0" && "$2" == "0" ]];
	then
		shift 2
		espeak -bg2 -s 150  -k2 -v de --punct="();{}[],.\"+*#'/-:=&\!_ \n<>|^\$\\@µ€~" \
			"$(cat $@)" 2>/dev/null
	else
		local a="$1"
		local b="$2"
		shift 2
		espeak -bg2 -s 150  -k2 -v de --punct="();{}[],.\"+*#'/-:=&\!_ \n<>|^\$\\@µ€~" \
			"$(cat $@ | head -$a | tail -$b)" 2>/dev/null
	fi
}

# 10+ char
function prime_check(){ # check if a number is prime
	openssl prime $@ | sed -e "s/[()isrmeot]//g"  | awk '{print $3 " " $2}'
}
function random_number(){ # generate a random number
	head -c1 /dev/urandom | \
	od -An -vtu1 | \
	tr -d ' '
}
function arduino-cli_move_int_main_to_sketch(){ ## two functions to move int main to some places
	~/.arduino15/own_modified_version/move.sh
}
function arduino-cli_move_int_main_to_arduino_folder(){
	~/.arduino15/own_modified_version/undo_move.sh
}
#-- END ALIAS + FUNCTION SECTION ---

### SCREENFETCH ###
if [[ ! -s ~/bin/screenfetch_tmp ]]; then
	touch ~/bin/screenfetch_tmp
	~/bin/screenfetch > ~/bin/screenfetch_tmp
fi
[[ "$(tty | head -c8)" == "/dev/tty" || "$(tty | head -c8)" == "/dev/pts" ]] && cat \
	~/bin/screenfetch_tmp 
#-- END SECRRENFECHT ---

### SET PS1 ###
SET_PS1
#-- END SET PS1 ---

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
