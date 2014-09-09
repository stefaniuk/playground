" no toolbar
set guioptions-=T

" set font
if has("unix")
    set guifont=Monospace\ 10
elseif has("win32")
    set guifont=Consolas:h10:cANSI
endif

" set theme
colors zendnb

" maximise window
"set lines=999 columns=999 " this causes some problems on Linux with multiple monitors

" file name in the title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}

" highlight all occurrences on double click
:noremap <silent> <2-LeftMouse> *
:inoremap <silent> <2-LeftMouse> <c-o>*
:map <silent> <Esc> :exe "noh"<CR>

" tabs
set tabpagemax=100
" open previously edited files in tabs on editor start
" switch current tab
" open and close tab
" move tabs

