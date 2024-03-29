#!/bin/bash
#    alias.sh -- contains all aliases, functions and conpletions
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

# 1 char
alias o="less -r"
alias q="exit"
alias s="systemctl"

# 2 char
alias ls='ls --color=auto'
alias ll="ls -la"
alias ip="ip -c"
alias am="alsamixer"
alias L8="echo 'LAYER 8 PROBLEM'"
alias hd="od -a"

## Autocompletion for tm ##
# tm<tab> shows tmux and tm
#alias tm="tmux"
#function _tm(){
#	COMPREPLY=($(compgen -W "`mal_ips_list`" "${COMP_WORDS[1]}"))
#}
#complete -F _tm tm
# so this is better:
# tm<tab> -> 'tmux '
# tmux <tab> -> list of options
complete -W "attach \
	split-window \
	rename-session \
	rename-window \
	new-session \
	new-window" tmux
#complete -F _tmux tmux

# 3 char
alias cls=clear
alias tig="git log --graph --oneline --all --color --decorate | less -R"
alias dir="dirs | sed $'s/^/\\e[32m/;s/\\\\s/\\\\n/g' | sed $'1,1s/$/\\e[0m/'"
function dns(){
	local this_arg this_dnstype query_item x_flag
	for this_arg in "$@"
	do
		x_flag="-x ";
		case ${this_arg##*.} in #((
			"ip"|"ip4"|"ipv4"|"ip6"|"ipv6")
				query_item="${this_arg%.*}"
			;;
			*)
				query_item="$this_arg"
				x_flag=""
			;;
		esac
		for this_dnstype in $DNS_TYPES
		do
			dig "$this_dnstype" "+noall" "+answer" "$x_flag$query_item"
		done
	done
}
alias ghc="ghc -dynamic"
function i3r(){
	#res="$(i3 $@ 2>&1 )"
	#echo "$res"
	#tail -n -1 <<< "$res" | \
	i3 $@ 2>&1 | \
		tail -n -1 | \
		json_pp -json_opt pretty | \
		sed -E '/^\s{4}/!d;s/^\s*//;s/,$//;s/^"input"/"_error_input_"/' | \
		sort | \
		sed -E "/^\"error\"/s/(['>],|:) (<|')/\1\n\t\2/g"

#17.11.2022 16:20:20 - Additional arguments passed. Sending them as a command to i3.
#[{"success":false,"parse_error":true,"error":"Expected one of these tokens: 'normal', 'pixel', 'toggle', 'none', '1pixel'","input":"borders pixel","errorposition":"      ^^^^^^^"}]
}

# 4 char
alias moon='weather "moon?lang=de"'
alias grep="grep --color=auto"
alias BOFH="telnet towel.blinkenlights.nl 666 2>/dev/null | tail -3 | head -2 "
alias motd="~/hacks/motd/new.sh"
alias sudi="sudo -s"
alias hell="git status; git log --graph --oneline --all --color --decorate | head -20"
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
function PATH(){
	echo "$PATH"

	### 0: nice sed/uniq/awk/sed solution:
	export PATH="$(
		echo $PATH | \
		sed -e 's/:/\n/g' | \
		uniq | \
		awk '{printf $0":"}' | \
		sed -e s/:\$//
	)"

	### 1: Ugly bash solution: NOT USE!!!
#	local data_array=()
#	local i j
#	for i in ${PATH//:/ }
#	do
#		for j in "${!data_array[@]}"
#		do
#			[[ "${data_array[j]}" == "$i" ]] && \
#				i="/dev/null"
#		done
#		[[ "/dev/null" != "$i" ]] && \
#			data_array=( "${data_array[@]}" "$i" )
#	done
#	data_array="${data_array[@]}:"
#	export PATH="${data_array// /:}"

	echo "$PATH"
}

# 5 char
alias image="fbi"
alias lsblk="lsblk -af"

# 6 char
alias bashrc=". ~/bin/bashrc"
alias brexit="cd; sudo clear ; screenfetch ; update"
alias brexit_hib="sudo systemctl hibernate; exit"
alias brexit_off="sudo shutdown; exit"
alias startx="startx 2>/dev/null >/dev/null; unset DISPLAY"
function qrcode(){
	curl -F-=\<- qrenco.de <<< "$@"
}
function jshell(){
	JAVA_HOME=/usr/lib/jvm/java-20-openjdk/ /usr/lib/jvm/java-20-openjdk/bin/jshell
}

# 7 char
alias vimbash="vim ~/bin/bashrc ~/bin/bash.rc/*"
alias minicom="sudo minicom -D /dev/ttyS0"
function rainbow(){
	for i in \
		{21..51..6} \
		{50..46} \
		{82..226..36} \
		{220..196..6} \
		{197..201} \
		{165..21..36}
	do
		echo -en "\e[48;5;${i}m\e[38;5;${i}m#\e[0m"
	done
	echo
}
function git_vor(){
	echo "$[
		$(git shortlog --summary | \
			awk '{print $1}'
		) - $(git shortlog --summary origin/master | \
			awk '{print $1}'
		)
	]"
}
function weather(){ 
	if [[ "$#" == 1 ]]; then
		curl "wttr.in/$1"
	else
		local item
		for item in "$@"
		do
			echo "$item"
			curl "wttr.in/$item" 2> /dev/null | \
				head -7 | \
				tail -5
		done
	fi
}

# 8 char
function dns_xxxx(){
	for i in {1..255}
	do
		dns "$i.$i.$i.$i.ip"
	done
}

# 9 char
alias sudo_edit="sudo EDITOR=vim visudo"
function read_code(){
	# read code
	# $1 = to line (0=all)
	# $2 = number of lines (0=all)
	# rest = files to read
	if [[ "$1" == "0" && "$2" == "0" ]];
	then
		shift 2
		espeak -bg2 -s 150  -k2 -v de --punct=\
			"();{}[],.\"+*#'/-:=&\!_ \n<>|^\$\\@µ€~" \
			"$(cat "$@")" 2>/dev/null
	else
		local a="$1"
		local b="$2"
		shift 2
		espeak -bg2 -s 150  -k2 -v de --punct=\
			"();{}[],.\"+*#'/-:=&\!_ \n<>|^\$\\@µ€~" \
			"$(cat "$@" | head "-$a" | tail -"$b")" 2>/dev/null
	fi
}

# 10+ char
function prime_check(){
	openssl prime "$@" | \
	sed -e "s/[()isrmeot]//g" | \
	awk '{print $3 " " $2}'
}
function random_number(){
	head -c1 /dev/urandom | \
	od -An -vtu1 | \
	tr -d ' '
}
function show_update_proc(){
	lsof | \
	grep 'DEL.*lib' | \
	cut -f 1 -d ' ' | \
	sort -u
}
function dont_forget(){
	LC_ALL=C git status | \
	sed -Ee '/deleted/!d;s/\sdeleted:\s*//;s#^mappings/(.+)/##;s/\.mapping//;s#^#net/minecraft/#' | \
	while read i;
		do grep --color -r -w -s $i mappings
	done
}
function mc_1120_item_dupe(){
	# to use: have inventory full of items that can be used in a crafting recipe
	# then open inv + recipe view, pick up the item you want to dupe and move to the outside (where items are dropped)
	# run this, wait for it to drop the item, after it threw it out, move mouse over a valid recipe
	
	# time to get back into mc
	sleep 2

	# throw out the item
	xdotool click 1

	# it takes 40gt (2s) to pick up the item, it works best if the slots of the crafting grid are already filled
	read -t 1.7

	# spam click the recipe while picking it up
	xdotool click --repeat 2000 --delay 0.5 1
}

# two functions to move int main to some places
function arduino-cli_move_int_main_to_sketch(){
	~/.arduino15/own_modified_version/move.sh
}
function arduino-cli_move_int_main_to_arduino_folder(){
	~/.arduino15/own_modified_version/undo_move.sh
}


function get_window_id(){
	xwininfo -name "$1" | sed -Ee '/Window id: /!d;s/^xwininfo: Window id: ([0-9A-Fa-fx]+) ".*"$/\1/'
}

# call it like this:
# compare_distances a 123 123 123 b 127 127 127 c 122 122 122
# it will print:
# a to c: 123
# b to c: 123
function compare_distances(){
	dc -e "10k $2 $3 $4 $6 $7 $8 ${10} ${11} ${12} dScSd dScSd dScSd SbSbSb SaSaSa [$1 to $9: ]P LaLc-d* LaLc-d* LaLc-d* ++vp [$5 to $9: ]P LbLd-d* LbLd-d* LbLd-d* ++vp"
}

function rgb_true_color_test(){
	awk -E - <<AWK

function hue_in_range(min, hue, max) {
	max_ = max % 6;
	if (max == 6) max_ = 6;
	return 256 * (min % 6) <= hue && hue < 256 * max_;
}
	
function hue2rgb_component(hue, offset) {
	value = hue % 256;

	if (hue_in_range(offset, hue, offset + 1) || hue_in_range(offset + 1, hue, offset + 2)) {
		return 0;
	} else if (hue_in_range(offset + 3, hue, offset + 4) || hue_in_range(offset + 4, hue, offset + 5)) {
		return 255;
	} else if (hue_in_range(offset + 2, hue, offset + 3)) {
		return value;
	} else if (hue_in_range(offset + 5, hue, offset + 6)) {
		return 255 - value;
	}
}
BEGIN{
	n = $COLUMNS;
	chars_per_line = 0;
	for (hue = 0; hue < 256 * 6; hue += 1) {
		value = hue % 256;
		
		r = hue2rgb_component(hue, 2);
		g = hue2rgb_component(hue, 4);
		b = hue2rgb_component(hue, 0);
		#printf "%d,%d;", hue,r;
		printf "\033[48;2;%d;%d;%dm \033[0m", r,g,b;

		chars_per_line++;
		if (hue != 0 && chars_per_line % n == 0) printf "\n";
	}
	printf "\n";
}
AWK
}
function jfr2flame() {
	JAVA_HOME=/usr/lib/jvm/java-17-openjdk /usr/lib/jvm/java-17-openjdk/bin/java -cp /opt/async-profiler/build/converter.jar jfr2flame $1 $2
}
# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
