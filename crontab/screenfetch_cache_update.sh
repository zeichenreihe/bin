#!/bin/bash
#    screenfetch_cache_update.sh -- update screenfetch cache
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

# remove screenfetch cache
rm $screenfetch_tmp

~/bin/bashrc 2>/dev/null >/dev/null

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
