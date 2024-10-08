" auto command
aug _Flast
au!
aug end

set nocompatible
filetype off

let s:dein_dir      = expand('~/.vim/dein')
let s:dein_repo_dir = expand('~/.vim/dein.vim')

if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

source ~/.vim/dein/.vimrc

" dein config
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml('~/.vim/dein.toml', {'lazy': 0})
    call dein#end()
    call dein#save_state()
endif

" plugin installation check
if dein#check_install()
    call dein#install()
endif

" plugin remove check
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif

" Vundle list
syntax on

filetype plugin on
filetype indent on

" 行数表示
set number
set backspace=indent,eol,start

if exists("&ambiwidth")
    set ambiwidth=double
endif

" 自動再読込
set autoread

" 出力に対しmoreを使う
set more

" beep関係
set novisualbell
set noerrorbells

" 空白部分代替文字
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:-

" 不可視文字表示設定
set list
set listchars=tab:>-,trail:~

" 省略表記の設定
set shortmess=aTW

" バックアップファイル関係
"set backupdir=$HOME/.vimbackup

" blowfishで暗号化
if v:version >= 703
    set cryptmethod=blowfish
endif

" インデント関係
set tabstop=4
set shiftwidth=2
set smarttab
set expandtab
set autoindent
set smartindent
set copyindent

" カーソル行に下線
set cursorline
" カーソル列に縦線
set cursorcolumn

" 補完関係
set completeopt=menu,preview
set wildmenu
set wildmode=list:longest,full

" 検索関係
" インクリメンタルサーチ
set incsearch

" タグファイルをバイナリサーチ
set tagbsearch

" 検索文字をハイライト
set hlsearch
nnoremap <silent> ,h :noh<CR>

" 検索文字列を画面の中央に
nnoremap <silent> n nzz

" 検索文字列が小文字の場合は大文字小文字を関係なく検索
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索
set smartcase

" <>をハイライト/ジャンプ対象に
set matchpairs+=<:>

" エンコーディング
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp-3,iso-2022-jp,euc-jp,sjis,utf-16,utf-16le,latin1

" タブ関係
nnoremap <silent> tt :tabedit<CR>
nnoremap <silent> th :tabm -1<CR>
nnoremap <silent> tl :tabm +1<CR>
set showtabline=2

" quickfix
nnoremap <C-c>n :cn<CR>
nnoremap <C-c><C-n> :cn<CR>
nnoremap <C-c>p :cp<CR>
nnoremap <C-c><C-p> :cp<CR>

" vsplit幅の変更
nnoremap <C-w><C-n> 10<C-w><
nnoremap <C-w>n <C-w><
nnoremap <C-w><C-w> 10<C-w>>
nnoremap <C-w>w <C-w>>

" マーカーでフォールディング
set foldmethod=marker
"set foldopen=all
"set foldclose=all

" ディレクトリの時の挙動
set browsedir=current
let g:netrw_liststyle = 1
let g:netrw_http_cmd = "wget -q -O"

" C-a/C-xのインクリメント/デクリメント
set nrformats-=octal
set nrformats+=alpha

" バッファ操作
" バッファのdiff
set diffopt=filler,vertical
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

" バイナリモード
nnoremap <C-m>b :%!xxd<CR>

" テキストモード
nnoremap <C-m>t :%!xxd -r<CR>

" リロード
nnoremap <Esc><C-l> :e!<CR>

" write via sudo
command! Sudow :w !sudo tee %

" スクロールのオフセット
set scrolloff=4

" ステータスライン
set ruler
set showcmd
set laststatus=2
set statusline=%<%f\ %m%r%h%q%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb=='1'?'(B)':'').']['.&ff.']'}%y%=%l,%c%V,0x%B\ %{noscrollbar#statusline(20,'.','#')}

set cmdheight=1

" ハイライト関係
" search plugin in runtimepath
function! s:exists_colorscheme(name)
    return !empty(split(globpath(&rtp, 'colors/'.a:name.'.vim'), '\n'))
endfunction

if s:exists_colorscheme('mxoria256')
    colorscheme mxoria256 "modified
elseif s:exists_colorscheme('xoria256')
    colorscheme xoria256 "fall-back to original scheme
else
    colorscheme desert
endif

highlight Targets cterm=underline ctermfg=lightblue guibg=white
au _Flast VimEnter,WinEnter * match Targets /　/

nmap <silent> m <Plug>(quickhl-manual-this)
vmap <silent> m <Plug>(quickhl-manual-this)
nmap <silent> M <Plug>(quickhl-manual-reset)
vmap <silent> M <Plug>(quickhl-manual-reset)

" 自動でディレクトリを生成する
au _Flast BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'))
function! s:auto_mkdir(dir)
    if !empty(matchstr(a:dir, '^scp://'))
        return
    endif
    if !isdirectory(a:dir)
        call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
endfunction

" cursor move in cmdline
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

" easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" ファイルタイプ別設定

" vim
au _Flast FileType vim setl shiftwidth=4
au _Flast FileType vim setl tw=0
au _Flast FileType vim setl smartindent cinwords=function,if,else,while

" sh/zsh
au _Flast FileType sh,zsh setl shiftwidth=4
au _Flast FileType sh,zsh setl noexpandtab

" configure/autoconf/Makefile/automake/gitconfig
au _Flast FileType config,make,automake,gitconfig setl shiftwidth=4
au _Flast FileType make,gitconfig setl noexpandtab

au _Flast FileType markdown syntax sync fromstart
" C/C++/D/CUDA

" サーチパスの設定
let $LOCAL_INCLUDE = "/usr/local/include"
au _Flast FileType c,cpp setl path+=$LOCAL_INCLUDE
au _Flast FileType c,cpp,cuda,d setl expandtab

" C用のインデントを用いる
au _Flast FileType c,cpp,cuda,d setl cindent
au _Flast FileType c,cpp,cuda,d setl cinkeys+=0<,0>

" 対応する各syntaxをハイライト
au _Flast FileType c,cpp,cuda setl matchpairs+=?::

" 関数を範囲選択(上が空行の必要あり)
"au _Flast FileType c,cpp,cuda,d nnoremap vf ][v[[?^\s*$<CR>

" 現在のブロックを範囲選択
"au _Flast FileType c,cpp,cuda,d nnoremap vb ?{<CR>%v%0

" 前後の関数へ移動
au _Flast FileType c,cpp,cuda,d nnoremap <C-j> /^\s*$<CR>]]?^\s*$<CR>jz<CR>
au _Flast FileType c,cpp,cuda,d nnoremap <C-k> [[?^\s*$<CR>jz<CR>

" インデント対象のステートメント
au _Flast FileType c,cpp,cuda,d setl smartindent cinwords=if,else,for,while,do,struct
au _Flast FileType cpp,cuda,d   setl smartindent cinwords=class,try,catch
au _Flast FileType d            setl smartindent cinwords=foreach,finaly

" python
" インデント対象のステートメント
au _Flast FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
au _Flast FileType python setl shiftwidth=4

" lisp
au _Flast FileType lisp setl nocindent lisp
au _Flast FileType lisp setl showmatch

" 前後の関数、マクロ、パッケージ、クラスへ移動
au _Flast FileType lisp nnoremap <C-j> j/defun \\|defmacro \\|defpackage \\|defclass <CR>z<CR>
au _Flast FileType lisp nnoremap <C-k> ?defun \\|defmacro \\|defpackage \\|defclass <CR>z<CR>

" 現在のブロックを範囲選択
au _Flast FileType lisp noremap vb ?(<CR>v%

" 現在の関数を範囲選択
au _Flast FileType lisp noremap vf ?defun <CR>?(<CR>v%

" haskell
au _Flast FileType haskell setl shiftwidth=2
let g:haskell_indent_if = 4

" Ada
au _Flast FileType ada setl shiftwidth=3 tabstop=3

" Erlang
au _Flast FileType erlang setl shiftwidth=4 tabstop=8 noexpandtab

" golang
au _Flast FileType go setl shiftwidth=4 noexpandtab

" plugins

" bufexplorer.vim
nnoremap <silent> <Esc>l :BufExplorer<CR>
let g:bufExplorerFindActive=0

" textmanip.vim
vmap <M-d> <Plug>(textmanip-duplicate-down)
nmap <M-d> <Plug>(textmanip-duplicate-down)

vmap <C-j> <Plug>(textmanip-move-down)
vmap <C-k> <Plug>(textmanip-move-up)
vmap <C-h> <Plug>(textmanip-move-left)
vmap <C-l> <Plug>(textmanip-move-right)

" gtags.vim
" XXX: 最後のスペースはそのまま出力し、そのまま検索文字列を入力するのに必要
nnoremap <silent> g# :GtagsCursor<CR>
nnoremap <C-g>/ :Gtags 
nnoremap <silent> <C-g><C-l> :Gtags -f %<CR>
nnoremap <C-g>g :Gtags -g 

" rfc.vim
if expand('%f') =~? 'rfc\d\+'
    setfiletype rfc
endif

" vim-anzu.vim
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" gundo
let g:gundo_close_on_revert = 1
nnoremap <silent> ;u :GundoShow<CR>

" PowerShell
if expand('%f') =~? '.ps1$'
    setfiletype ps1
endif

" linediff
vnoremap <silent> L :Linediff<CR>
