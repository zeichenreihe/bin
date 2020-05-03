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

" enable mouse mode
set mouse=a

" latex
set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
set runtimepath=~/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,~/.vim/after

