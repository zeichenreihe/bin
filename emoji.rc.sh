#!/bin/bash
#    emoji.rc.sh - include emoji
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

function RANDOM_EMOJI(){
	local return_state=$1
	local EMOJI=(🐧 🦄 🐰 🐹 🐟 🐡 🐝 🌴 "🏝️ " 🥥 🎄 "☃️ " 🏁 🎁 💎 📱 \
		📻 🔋 "🖥️ " 💾 💻 "🏜️ " 💶 🍉 🍋 🥨 🍪 🎂 😎 🤓 🤖 🎅)
	local BAD_RETURN=(💩 💥 ⚡ 🚽 💣 "🕳️ " 🛑 "⚠️ " "☢️ " ❗ ❕ "‼️ " "⁉️ " ❓ ❔ ❕ \
		"ℹ️ " 🆘 👎)
	local selected=${EMOJI[$RANDOM % ${#EMOJI[@]}]}
	[[ $return_state -eq 0 ]]||selected=${BAD_RETURN[$RANDOM % ${#BAD_RETURN[@]}]}
	[[ $return_state == "linux" ]]&&selected=${EMOJI[0]}
	echo "$selected"
}

# nice to have:
#🌍💲🚴♟️🎤🥨🍪🎂

# syntax
# vim: ts=8 sts=8 sw=8 noet si syntax=bash
