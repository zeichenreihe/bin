pacman -Si $(pacman -Qq) | grep Lizenzen | sort -u | sed 's/Lizenzen                 : //g ; s/:/ /g ; s/ /\n/g' | sort -u
