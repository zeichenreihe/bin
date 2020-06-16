" vimrc-file
" vim: set ts=8 sts=8 sw=8 noet si syntax=vimrc

" normal with numbers
set number

" syntax on
syntax on
filetype plugin on

" html syntax in php strings
let php_htmlInStrings = 1

" remrmber last pos
au BufReadPost *
	\ if line("'\"") > 1 && line("'\"") <= line("$") |
	\	exe "normal! g`\"" |
	\ endif

" allow only 72 character for email
au BufRead /tmp/mutt-* set tw=72

" enable mouse mode
set mouse=a

" enable dark mode if in TMUX
if $TMUX != ""
	set background=dark
else
	set background=light
endif
if $DISPLAY != ""
	set background=dark
else
	set background=light
endif

" latex
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

