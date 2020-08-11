#!/bin/bash
#    loader.sh -- crontab loader
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

# This script calls itself with -e and the name of the file to edit.
if [[ $1 == "-e" ]]; then
	# the self call
	file_to_load="$2"
	crontab_file="$3"

	# Backup old crontab
	backup="/tmp/old_crontab.cron"
	mv $crontab_file $backup
	echo "Old crontab saved to $backup."

	# write new crontab
	cp $file_to_load $crontab_file
	echo "New crontab $file_to_load loadet."
else
	# the user calls the script
	file_to_load="$1"
	EDITOR="$0 -e $file_to_load" crontab -e
fi

exit 0

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
