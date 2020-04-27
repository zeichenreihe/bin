#    makefile for all somtimes needet things
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

# network
j: wlan update

wlan: 
	sudo /usr/bin/wifi-menu
#dhcpcd wlp2s2

wlan_int:
	sudo /usr/bin/wifi-menu wlp2s2

wlan_ext:
	sudo /usr/bin/wifi-menu wlp0s29f7u1

lan:
	sudo /usr/bin/dhcpcd enp2s0

#lan_pixy:
#	sudo /usr/bin/dhcpcd enp0s25

resolv:
	sudo /usr/bin/vim /etc/resolv.conf

# all services
sshd:
	sudo /usr/bin/systemctl start sshd.service

sshd_stop:
	sudo /usr/bin/systemctl stop sshd.service

httpd:
	sudo systemctl start httpd

httpd_stop:
	sudo systemctl stop httpd

serial_getty:
	sudo systemctl start getty@ttyS0

serial_getty_stop:
	sudo systemctl stop getty@ttyS0

# useful things
update:
	~/bin/update

off:
	sudo shutdown

hib:
	sudo systemctl hibernate

poweroff:
	sudo systemctl poweroff

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=make
