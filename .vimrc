filetype off
"call pathogen#runtime_append_all_bundles()
execute pathogen#infect()
call pathogen#helptags()

"{{{Auto Commands

" Automatically cd into the directory that the file is in
"autocmd BufEnter * execute "chdir ".escape(expand("%:p:h"), ' ')

" Remove any trailing whitespace that is in the file
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

"}}}

"{{{Misc Settings

" Necesary  for lots of cool vim things
set nocompatible

" This shows what you are typing as a command.  I love this!
set showcmd

" Folding Stuffs
set foldmethod=manual

" Needed for Syntax Highlighting and stuff
filetype on
filetype plugin on
syntax enable
set grepprg=grep\ -nH\ $*

" Who doesn't like autoindent?
set autoindent

" Spaces are better than a tab character
set noexpandtab
set smarttab

" Who wants an 8 character tab?  Not me!
set shiftwidth=8
set softtabstop=8
set tabstop=8

" Use english for spellchecking, but don't spellcheck by default
if version >= 700
        set spl=en spell
        set nospell
endif

" Real men use gcc
"compiler gcc

" Cool tab completion stuff
set wildmenu
set wildmode=list:longest,full

" Enable mouse support in console
set mouse=""

" Got backspace?
set backspace=2

" Line Numbers PWN!
set number

" Ignoring case is a fun trick
set ignorecase

" And so is Artificial Intellegence!
set smartcase

" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

nnoremap JJJJ <Nop>

" Incremental searching is sexy
set incsearch

" Highlight things that we find with the search
set hlsearch

" Since I use linux, I want this
let g:clipbrdDefaultReg = '+'

" When I close a tab, remove the buffer
set nohidden

" Set off the other paren
highlight MatchParen ctermbg=4
" }}}

"{{{Look and Feel

" Favorite Color Scheme
if has("gui_running")
        colorscheme inkpot
        " Remove Toolbar
        set guioptions-=T
        "Terminus is AWESOME
        set guifont=Terminus\ 9
endif

"Status line gnarliness
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]


function! Browser ()
        let line = getline (".")
        let line = matchstr (line, "http[^   ]*")
        exec "!konqueror ".line
endfunction

"}}}

"{{{Theme Rotating
let themeindex=0
function! RotateColorTheme()
        let y = -1
        while y == -1
                let colorstring = "inkpot#ron#blue#elflord#evening#koehler#murphy#pablo#desert#torte#"
                let x = match( colorstring, "#", g:themeindex )
                let y = match( colorstring, "#", x + 1 )
                let g:themeindex = x + 1
                if y == -1
                        let g:themeindex = 0
                else
                        let themestring = strpart(colorstring, x + 1, y - x - 1)
                        return ":colorscheme ".themestring
                endif
        endwhile
endfunction
" }}}

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
        if g:paste_mode == 0
                set paste
                let g:paste_mode = 1
        else
                set nopaste
                let g:paste_mode = 0
        endif
        return
endfunc
"}}}

"{{{ Todo List Mode

function! TodoListMode()
        e ~/.todo.otl
        Calendar
        wincmd l
        set foldlevel=1
        tabnew ~/.notes.txt
        tabfirst
        " or 'norm! zMzr'
endfunction

"}}}

"}}}

"{{{ Mappings

" Open Url on this line with the browser \w
map <Leader>w :call Browser ()<CR>

" Open the Project Plugin <F2>
nnoremap <silent> <F2> :Project<CR>

" Open the Project Plugin
nnoremap <silent> <Leader>pal  :Project .vimproject<CR>

" TODO Mode
nnoremap <silent> <Leader>todo :execute TodoListMode()<CR>

" Open the TagList Plugin <F3>
nnoremap <silent> <F3> :Tlist<CR>

" Next Tab
nnoremap <silent> <C-Right> :tabnext<CR>

" Previous Tab
nnoremap <silent> <C-Left> :tabprevious<CR>

" New Tab

" Rotate Color Scheme <F8>
nnoremap <silent> <F8> :execute RotateColorTheme()<CR>

" DOS is for fools.
nnoremap <silent> <F9> :%s/$//g<CR>:%s// /g<CR>

" Paste Mode!  Dang! <F10>
nnoremap <silent> <F10> :call Paste_on_off()<CR>
set pastetoggle=<F10>

" Edit vimrc \ev
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>
nnoremap <silent> <Leader>lv :source ~/.vimrc<CR>

" Edit gvimrc \gv
nnoremap <silent> <Leader>gv :tabnew<CR>:e ~/.gvimrc<CR>

" Up and down are more logical with g..
nnoremap <silent> k gk
nnoremap <silent> j gj
inoremap <silent> <Up> <Esc>gka
inoremap <silent> <Down> <Esc>gja

" Good call Benjie (r for i)
nnoremap <silent> <Home> i <Esc>r
nnoremap <silent> <End> a <Esc>r

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Space will toggle folds!
nnoremap <space> za

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Testing
set completeopt=longest,menuone,preview
let g:SuperTabDefaultCompletionType = "context"

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
inoremap <expr> <c-n> pumvisible() ? "\<lt>c-n>" : "\<lt>c-n>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"
inoremap <expr> <m-;> pumvisible() ? "\<lt>c-n>" : "\<lt>c-x>\<lt>c-o>\<lt>c-n>\<lt>c-p>\<lt>c-r>=pumvisible() ? \"\\<lt>down>\" : \"\"\<lt>cr>"

" Swap ; and :  Convenient.
"nnoremap ; :
"nnoremap : ;

" Fix email paragraphs
nnoremap <leader>par :%s/^>$//<CR>

"ly$O#{{{ "lpjjj_%A#}}}jjzajj

"}}}

"{{{Taglist configuration
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_SingleClick = 1
let Tlist_Inc_Winwidth = 0
"}}}

let g:rct_completion_use_fri = 1
"let g:Tex_DefaultTargetFormat = "pdf"
let g:Tex_ViewRule_pdf = "kpdf"

filetype plugin indent on
syntax on
set tags+=../tags
set tags+=$TAGDIR
if has("cscope")
        if filereadable("cscope.out")
                cs add cscope.out
        endif
        if filereadable("../cscope.out")
                cs add ../cscope.out ..
        endif
endif

map <C-\> :cs find 3 <C-R>=expand("<cword>")<CR><CR>

autocmd FileType python setl ts=4 sts=4 sw=4 expandtab sr
autocmd FileType python if has('python3') | set omnifunc=python3complete#Complete | endif
autocmd FileType python :set tags+=/usr/lib/python3.4/python_tags
autocmd FileType python :set tags+=/usr/local/lib/python3.4/tags
autocmd FileType text   :set syntax=c
autocmd FileType python :cs add /usr/lib/python3.4/cscope.out /usr/lib/python3.4

function! Insert_comment()
        if (&filetype == "python" || &filetype == "sh")
                let comment = "#"
        elseif (&filetype == "vim")
                let comment = "\""
        else
                let comment = "//"
        endif
        let insert_parse = "\<Esc>I" . comment ."\<Esc>"
        :execute "normal" . insert_parse
endfunction

map  <Leader>c :call Insert_comment()<CR>

highlight BadWhiteSpace ctermbg=red guibg=red
match BadWhiteSpace /[^ \t]\s\{1,\}$/


"autocmd CursorMovedI * if pumvisible() == 0|silent! pclose|endif
"autocmd InsertLeave  * if pumvisible() == 0|silent! pclose|endif
"

"load vimrc file
"autocmd BufWritePost *.vimrc source ~/.vimrc
map <Leader>lv :source ~/.vimrc<CR>
nmap ,ls :ls<CR>

imap <C-w> <Esc>2wi
imap <C-l> <Esc>2li
imap <C-h> <Esc>i
imap <C-b> <Esc>bi
"imap <C-0> <Esc>0i
"imap <C-4> <Esc>$a
map <C-q> :q<CR>
imap zz a<Esc>zz`.xa
"auto ident when write to file
"autocmd BufWrite *.c,*.py execute "silent normal" . s:ident
"ident file when quit the vim
let s:ident = "\<Esc>gg=G'':w\<CR>"
function! Check_ident()
        if filewritable(expand("%"))
                :execute "normal" . s:ident
        endif
endfunction
map <Leader>q :call Check_ident()<CR>
"autocmd QuitPre *.c,*.py call Check_ident()

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

function! Head_src_tran()
        let str = expand("%:p")
        let len = strlen(str)
        let to_filename = strpart(str, 0, len - 1) . tr(strpart(str, len - 1), "ch", "hc")
        :execute "e " . to_filename
endfunction

function! Test()
endfunction
map <F5> <Esc>:w<CR>:call Run_prog()<CR>
map 00 0w
"semaphore.h
map <Leader>h :w<CR>:call Head_src_tran()<CR>

set path+=..,%:p:h


let g:gundo_prefer_python3 = 1
map <leader>gu :GundoToggle<CR>
let g:SuperTabMappingForward = '<c-tab>'
