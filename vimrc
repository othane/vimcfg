
set nocompatible              " be iMproved, required
filetype off                  " required

syntax on
filetype plugin indent on

"behave mswin
"source $VIMRUNTIME/mswin.vim
set t_Co=256
set mousemodel=popup
set mouse=a

colorscheme molokai
if &diff
"   colorscheme github
    colorscheme molokai
endif

if has("gui_gtk2") && has("gui_running")
    set columns=90
    set lines=40
endif

" Set doxygen syntax on always 
let g:load_doxygen_syntax=1

" ctags / cscope
set tags=./tags;
let g:tagbar_left = 1

" programming niceness
set autoindent

" Help vim, fix my broken brain !
set spell
set number

" up/down font size quickly
let s:pattern = '^\(.* \)\([1-9][0-9]*\)$'
let s:minfontsize = 6
let s:maxfontsize = 16
function! AdjustFontSize(amount)
    if has("gui_gtk2") && has("gui_running")
        let fontname = substitute(&guifont, s:pattern, '\1', '')
        let cursize = substitute(&guifont, s:pattern, '\2', '')
        let newsize = cursize + a:amount
        if (newsize >= s:minfontsize) && (newsize <= s:maxfontsize)
            let newfont = fontname . newsize
            let &guifont = newfont
        endif
    else
        echoerr "You need to run the GTK2 version of Vim to use this function."
    endif
endfunction

" key combos
map <F12> :TagbarToggle<CR>
map <F11> :TagbarShowTag<CR>

map <A-F12> :!ctags -R --c++-kinds=+p --fields=+liaS --extra=+q -I packed+ .<CR>
map <C-F12> :!ctags -R --fields=+l --languages=python,javascript --python-kinds=-vi -f ./tags `find ./ -name "*.py" -o -name "*.js"`<CR>
map <C-F11> :!ctags -R --fields=+l --languages=python,javascript --python-kinds=-vi -f $VIRTUAL_ENV/tags `find ./ -name "*.py" -o -name "*.js"`<CR>
"map <A-F12> :!find . -type f -iregex ".*\.js$" -exec jsctags {} -f \; <bar> sed "/^$/d" <bar> sort > jstags<CR>
map <leader><F12> :!ctags -R --c++-kinds=+p --fields=+liaS --extra=+q -I packed+ --languages=+python,javascript --python-kinds=-vi -f ./tags `find ./ -name "*.py" -o -name "*.js" -o -name "*.c" -o -name "*.cpp" -o -name "*.h"`<CR>
map <leader><F11> :!ctags -R --fields=+l --languages=+python --python-kinds=-vi -f $VIRTUAL_ENV/tags `find ./ -name "*.py"`<CR>

"map <C-F> :lvim /<c-r>=expand("<cword>")<cr>/j ./**/*.[ch] ./**/*.cpp ./**/*.py ./**/*.js ./**/*.html<CR>:lw<CR>A
map <C-F> :lvim /<c-r>=expand("<cword>")<cr>/j ./**/*.[ch] ./**/*.cpp ./**/*.py ./**/*.js ./**/*.html $VIRTUAL_ENV/**/*.py<CR>:lw<CR>
map <C-S-F2> :set binary<cr> :set noeol<CR>
map <C-P>%!python -m json.tool<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

map <C-F1> :set autoindent<cr> :set noexpandtab<cr> :set softtabstop=0<CR> :set shiftwidth=4<CR> :set tabstop=4<CR>
map <C-F2> :set autoindent<cr> :set expandtab<CR> :set softtabstop=2<CR> :set shiftwidth=2<CR>
map <C-F4> :set autoindent<cr> :set expandtab<CR> :set softtabstop=4<CR> :set shiftwidth=4<CR>

map <Leader><F1> :set autoindent<cr> :set noexpandtab<cr> :set softtabstop=0<CR> :set shiftwidth=4<CR> :set tabstop=4<CR>
map <Leader><F2> :set autoindent<cr> :set expandtab<CR> :set softtabstop=2<CR> :set shiftwidth=2<CR>
map <Leader><F4> :set autoindent<cr> :set expandtab<CR> :set softtabstop=4<CR> :set shiftwidth=4<CR>

"
" file type shortcuts
"
au FileType python noremap <buffer> <localleader>p oimport ipdb; ipdb.set_trace()<esc>
au FileType python noremap <buffer> <localleader>P Oimport ipdb; ipdb.set_trace()<esc>
au FileType python set tags+=$VIRTUAL_ENV/tags

au FileType javascript noremap <buffer> <localleader>p odebugger<esc>
au FileType javascript noremap <buffer> <localleader>P Odebugger<esc>

au FileType C set omnifunc=ccomplete#Complete

autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen

" for now I do a lot of django so lets treat all html as django since the auto
" detect is flakey
au BufNewFile,BufRead *.html set filetype=htmldjango
au FileType htmldjango noremap <buffer> <localleader>p o{% load debug_tags %}{% set_trace %}{# 'template_debug' #}<esc>
au FileType htmldjango noremap <buffer> <localleader>P O{% load debug_tags %}{% set_trace %}{# 'template_debug' #}<esc>

map <A-Up> :call AdjustFontSize(1)<CR>
map <A-Down> :call AdjustFontSize(-1)<CR>
let g:miniBufExplModSelTarget = 1
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %
ca jsonpp :%!jq '.'
ca doff :diffoff<cr> :set noscrollbind<cr> :set nocursorbind<cr>

" WinMerge Me
nmap <a-down> ]czz
nmap <a-up> [czz
nmap <a-left> :diffput<cr>
nmap <a-right> :diffput<cr>

if &diff
	" double the width up to a reasonable maximum
	let &columns = ((&columns*2 > 140)? 140: &columns*2)
endif

" stop large tags files from freezing the whole thing when you stop typing for
" a while
let g:easytags_on_cursorhold = 0
let g:easytags_auto_update = 0
let g:easytags_events = []
"let g:easytags_file = './vimtags'

" fix jedi slownesses
let g:jedi#show_call_signatures = 0
let g:jedi#popup_on_dot = 0

set nobackup
set nowritebackup
set noswapfile
set guioptions+=b
set guioptions-=L
set hlsearch
set expandtab
set tabstop=4
set showcmd
" fix weird vim behaviour
set nomousehide
set nowrap

set autoindent
set noexpandtab
set softtabstop=0
set shiftwidth=4
set tabstop=4

set printexpr=PrintFile(v:fname_in)
function PrintFile(fname)
  call system("kprinter " . a:fname)
  call delete(a:fname)
  return v:shell_error
endfunc

runtime macros/matchit.vim

"set listchars=eol:\u23ce,tab:\u2420,trail:\u2420,nbsp:\u23b5
set listchars=trail:·,space:·,tab:__
set list
hi SpecialKey ctermfg=grey guifg=grey40

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

"let g:airline_powerline_fonts = 1
"let g:airline_theme='desertink'

if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end

" complete like bash, then list like bash, then guess like vim does by default
set wildmode=longest,list,full

