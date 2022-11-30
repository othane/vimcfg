set nocompatible              " be iMproved, required
filetype off                  " required

syntax on
"syntax sync fromstart
syntax sync minlines=100000
set synmaxcol=100000
filetype plugin indent on

"behave mswin
"source $VIMRUNTIME/mswin.vim
set t_Co=256
set mousemodel=popup
set mouse=a

colorscheme gruvbox
set bg=dark
if &diff
"   "colorscheme github
    colorscheme molokai
endif

if has("gui_gtk2") && has("gui_running")
    set columns=90
    set lines=40
endif

" Set doxygen syntax on always 
let g:load_doxygen_syntax=1

au BufRead,BufNewFile nginx.conf setfiletype nginx

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
map <C-F12> :!ctags -R --fields=+l --languages=python,javascript,go --python-kinds=-vi -f ./tags `find ./ -name "*.py" -o -name "*.js"`<CR>
map <C-F9> :!ctags -R --fields=+l --languages=python,javascript --python-kinds=-vi -f $VIRTUAL_ENV/tags `find ./ -name "*.py" -o -name "*.js"`<CR>
"map <A-F12> :!find . -type f -iregex ".*\.js$" -exec jsctags {} -f \; <bar> sed "/^$/d" <bar> sort > jstags<CR>
"map <leader><F12> :!ctags -R --c++-kinds=+p --fields=+liaS --extra=+q -I packed+ --languages=+python,javascript --python-kinds=-vi -f ./tags `find ./ -name "*.py" -o -name "*.js" -o -name "*.c" -o -name "*.cpp" -o -name "*.h"`<CR>
map <leader><F12> :!ctags -R -f ./tags<CR>
map <leader><F9> :!ctags -R --fields=+l --languages=+python --python-kinds=-vi -f $VIRTUAL_ENV/tags `find ./ -name "*.py"`<CR>

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
    let &columns = ((&columns*2 > 240)? 240: &columns*2)
    let &lines = ((&lines*4 > 62)? 62: &lines*4)
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
function! PrintFile(fname)
  call system("kprinter " . a:fname)
  call delete(a:fname)
  return v:shell_error
endfunc

runtime macros/matchit.vim

"set listchars=eol:\u23ce,tab:\u2420,trail:\u2420,nbsp:\u23b5
set listchars=tab:→\ ,space:·,trail:·
set list
function! ToggleList()
	let w:listcharson = get(w:, 'listcharson', 1)
	if (w:listcharson)
		let w:listcharson = 0
		set nolist
	else
		let w:listcharson = 1
		set list
	endif
endfunction
map <leader>l :call ToggleList()<cr>
hi SpecialKey ctermfg=grey guifg=grey40

"inspired by https://www.reddit.com/r/vim/comments/6hbsh8/zoom_window_tmux_style_zoom_pane_in_vim/
let g:zoom_state = 0
function! s:zoom_toggle() abort
	let restore_cmd = winrestcmd()
	wincmd |
	wincmd _
	if (g:zoom_state)
		let g:zoom_state = 0
		exe t:zoom_restore
		"set number
		set list
	else
		let g:zoom_state = 1
		let t:zoom_restore = restore_cmd
		"set nonumber
		set nolist
	endif
endfunction
map <leader>z :call <SID>zoom_toggle()<cr>

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

if has("autocmd")
	au VimEnter,InsertLeave * silent execute '!echo -ne "\e[1 q"' | redraw!
	au InsertEnter,InsertChange *
		\ if v:insertmode == 'i' | 
		\ silent execute '!echo -ne "\e[5 q"' | redraw! |
		\ elseif v:insertmode == 'r' |
		\ silent execute '!echo -ne "\e[3 q"' | redraw! |
		\ endif
	au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif
set ttimeoutlen=0
set ttyfast

set cul

" cnoreabbrev tn tabnext
" cnoreabbrev tp tabprev

"set clipboard=unnamedplus
set clipboard=unnamed

let g:tsuquyomi_disable_quickfix = 1

" set paste
set nocursorline

nnoremap <C-w>) :vert winc ]<CR>

" Move up and down in autocomplete with <c-j> and <c-k>
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" moving aroung in command mode
cnoremap <c-h> <left>
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-l> <right>

set diffexpr=DiffW()
function DiffW()
  let opt = ""
  if &diffopt =~ "icase"
    let opt = opt . "-i "
  endif
  if &diffopt =~ "iwhite"
    let opt = opt . "-w " " swapped vim's -b with -w
  endif
  silent execute "!diff -a --binary " . opt .
  \ v:fname_in . " " . v:fname_new .  " > " . v:fname_out
endfunction
