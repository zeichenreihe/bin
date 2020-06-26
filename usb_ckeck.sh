#!/bin/bash
#    usb_check.sh -- print warning with notify-send for usb devices
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

title="USB-Keyboard plugged in"
msg=""

function warn(){
	notify-send -i input-$1 "$2" "$3"
}

case $1 in # ((((
	"k"|"keyboard") warn keyboard "USB-Keyboard plugged in" "This can be bad or good.";;
	"m"|"mouse") warn mouse "USB-Mouse plugged in" "This can be bad or good.";;
	"t"|"tablet") warn tablet "Graphics tablet plugged in" "This can be bad or good.";;
	"g"|"game") warn gaming "Game controller plugged in" "This can be bad or good.";;
esac

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
