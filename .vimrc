"--- setting---


" Necesary  for lots of cool vim things
set nocompatible

" Number line
set number

" This shows what you are typing as a command.
set showcmd

" Folding Stuffs
set foldmethod=manual

" Indent
set autoindent
set shiftround

" Syntax Highlighting
filetype on
filetype plugin indent on
syntax enable
set grepprg=grep\ -nH\ $*

" Tab instead of space
set noexpandtab
set smarttab

" Path
set path+=..,%:p:h

" Shiftwidth 8 in kernel, 4 for others?
set shiftwidth=8
set softtabstop=8
set tabstop=8

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=""

" Got backspace?
set backspace=2

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" When I close a tab, remove the buffer
set nohidden

"Status line
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" TODO Mode
function! TodoListMode()
	tabnew ~/.todo
endfunction
nnoremap <silent> <Leader>todo :execute TodoListMode()<CR>

" Open Url on this line with the browser \w
function! Browser ()
	let line = getline (".")
	let line = matchstr (line, "http[^   ]*")
	exec "!chrome ".line
endfunction
map <Leader>w :call Browser ()<CR>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>
nnoremap <silent> <Leader>lv :source ~/.vimrc<CR>

" Tags & Cscope
set tags +=../tags
if has("cscope")
	if filereadable("cscope.out")
		cs add cscope.out
	endif
	if filereadable("../cscope.out")
		cs add ../cscope.out ..
	endif
endif
map <C-\> :cs find 3 <C-R>=expand("<cword>")<CR><CR>

" Highlight wrong space
highlight BadWhiteSpace ctermbg=red guibg=red
match BadWhiteSpace /[^ \t]\s\{1,\}$/


"--- maps ---
imap zz a<Esc>zz`.xa

" adding...
function! Run_cmd(args)
	let cmd = expand("%:p") . " " . join(a:args)
	:echo "\n"
	let result = system(cmd)
	echo result
	if matchstr(result, "TraceBack") != ""
		let line = matchlist(result, 'line \([0-9]\+\)')
		:exe "normal" line[1] . "G"
	endif
endfunction
function! Run_prog()
	if matchstr(getfperm(@%), 'x') == ""
		let mode = input("file not executable, chmod?[Y/N]: ")
		if mode == 'N'
			return 0
		else
			call system('chmod +x ' . @%)
		endif
	endif
	"call inputsave()
	let line = input("set args: ")
	call Run_cmd(split(line))
	"call inputrestore()
endfunction

map <F5> <Esc>:w<CR>:call Run_prog()<CR>


"--- Auto cmds ---

" Automatically cd into the directory that the file is in
"autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespaces
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
	au!
	autocmd BufReadPost *
				\ if expand("<afile>:p:h") !=? $TEMP |
				\   if line("'\"") > 1 && line("'\"") <= line("$") |
				\     let JumpCursorOnEdit_foo = line("'\"") |
				\     let b:doopenfold = 1 |
				\     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
				\        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
				\        let b:doopenfold = 2 |
				\     endif |
				\     exe JumpCursorOnEdit_foo |
				\   endif |
				\ endif
	" Need to postpone using "zv" until after reading the modelines.
	autocmd BufWinEnter *
				\ if exists("b:doopenfold") |
				\   exe "normal zv" |
				\   if(b:doopenfold > 1) |
				\       exe  "+".1 |
				\   endif |
				\   unlet b:doopenfold |
				\ endif
augroup END

" adding...
autocmd FileType python setl ts=4 sts=4 sw=4 expandtab sr
autocmd FileType python if has('python3') | set omnifunc=python3complete#Complete | endif
autocmd FileType python :set tags+=/usr/lib/python3.4/python_tags
autocmd FileType python :set tags+=/usr/local/lib/python3.4/tags
autocmd FileType python :cs add /usr/lib/python3.4/cscope.out /usr/lib/python3.4
