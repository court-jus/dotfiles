set nocompatible
filetype off
set rtp+=~/.vim/bundle/vundle/
#call vundle#rc()
#Plugin 'gmarik/vundle'
filetype plugin indent on

syn on
colorscheme solarized
set background=dark
set nocompatible
set nomousehide
set autoindent
set nobackup
set tabstop=4
set shiftwidth=4
set wildmenu
set encoding=utf-8
set expandtab
set hls
set ruler
set rulerformat=%55(%f\ %{GitBranchInfoString()}\ %{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)

au BufNewFile,BufRead *.go setf go

filetype on
filetype plugin on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType go map <F4> :!make test<CR>

" %% expand to the path of the current open file
cabbr <expr> %% expand('%:p:h')

" Pydoc help via <F2>
map <F2> :BufExplorer<CR>

" coding unicode python
map <F4> :0<CR>O# -*- coding: utf-8 -*-

" TlistToggle Open/Close via <F3>
map <F3> :TlistToggle<CR>
map <F5> :bd<CR>
map <F6> :update<CR>
map <F7> <C-^>

" select all copy
map <C-a> ggVG
map <C-c> "+y



" Next error (or match) (used for vimgrep) "
map <F9> :cn<CR>
" Previous error
map <S-F9> :cp<CR>
" Show error list
map <C-F9> :copen<CR>
" Close error list
map <C-S-F9> :cclose<CR>
" Prepare a vimgrep search on the current word
map <F10> :vimgrep <C-R><C-W> 
" Launch a vimgrep on the current word for all the file in the current working
" directory
map <S-F10> :vimgrep <C-R><C-W> *<CR>
" Launch a vimgrep on the current word for all the file RECURSIVELY in the
" current working directory
map <C-S-F10> :vimgrep <C-R><C-W> **/*<CR>


" vu sur http://vim.wikia.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

map <F11> :DiffSaved<CR>
map <S-F11> :diffoff<CR>

map @ `

set list
set lcs:tab:>-,trail:.

autocmd BufNewFile,BufRead */unknown-horizons/* set noexpandtab
autocmd BufNewFile,BufRead */unknown-horizons/* set shiftwidth=8
autocmd BufNewFile,BufRead */unknown-horizons/* set tabstop=8

" fichier en question

"Python
autocmd BufNewFile,BufRead *.py inorea <buffer> cfun <c-r>=IMAP_PutTextWithMovement("def <++>(<++>):\n<++>\nreturn <++>")<CR>
autocmd BufRead,BufNewFile *.py inorea <buffer> cclass <c-r>=IMAP_PutTextWithMovement("class <++>:\n<++>")<CR>
autocmd BufRead,BufNewFile *.py inorea <buffer> cfor <c-r>=IMAP_PutTextWithMovement("for <++> in <++>:\n<++>")<CR>
autocmd BufRead,BufNewFile *.py inorea <buffer> cif <c-r>=IMAP_PutTextWithMovement("if <++>:\n<++>")<CR>
autocmd BufRead,BufNewFile *.py inorea <buffer> cifelse <c-r>=IMAP_PutTextWithMovement("if <++>:\n<++>\nelse:\n<++>")<CR>

"Press c-q insted of space (or other key) to complete the snippet
imap <C-q> <C-]>

autocmd Filetype java setlocal omnifunc=javacomplete#Complete


#Bundle 'wakatime/vim-wakatime'
