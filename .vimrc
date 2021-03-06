set nocompatible
set title
set ruler
set smartindent
set noexpandtab
set backspace=indent,eol,start
set mouse=a
set enc=utf-8
set fencs=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932,utf-16le,utf-16,default

"バッファを保存しなくても他のバッファを表示できるようにする
set hidden

"コマンド補完
set wildmenu

"タイプ途中のコマンドを最下行に表示
set showcmd

"行番号を表示
set number

set autoindent
set cindent
set smarttab
set tabstop=4
set shiftwidth=4
set tags=tags;

"インクリメンタルサーチを有効
set incsearch

"検索時に大文字小文字を区別しない
"ただし，検索文字列に大文字小文字が混在しているときは区別する
set ignorecase
set smartcase

"検索文字列の強調表示
set hlsearch

"ステータスラインを常に表示する
set laststatus=2

"折りたたみ設定
set foldenable
set foldmethod=syntax

"折り返し無効
set nowrap

"スペルチェック
set spelllang=en,cjk
set spell

"Trailing whitespace対策
" http://vim.wikia.com/wiki/Highlight_unwanted_spaces
" http://www.bestofvim.com/tip/trailing-whitespace/
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

function! TrimExtraWhitespace()
	%s/\s\+$//e
endfunction

nnoremap <silent> <Leader>rts :call TrimExtraWhitespace()<CR>

autocmd FileWritePre   * :call TrimExtraWhitespace()
autocmd FileAppendPre  * :call TrimExtraWhitespace()
autocmd FilterWritePre * :call TrimExtraWhitespace()
autocmd BufWritePre    * :call TrimExtraWhitespace()


"----- Vundle -----------------------------------------

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'Align'
Plugin 'majutsushi/tagbar'

Plugin 'y-ishida/vim-vala'

Plugin 'godlygeek/tabular'

Plugin 'tyru/open-browser.vim'
Plugin 'kannokanno/previm'

"-- for HTML/CSS/JS
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'

"-- 各種言語用の構文サポート
Plugin 'sheerun/vim-polyglot'

"-- 構文チェッカー
Plugin 'vim-syntastic/syntastic'

Plugin 'pangloss/vim-javascript'
Plugin 'moll/vim-node'

"-- Python の自動補完
Plugin 'davidhalter/jedi-vim'

Plugin 'tomasr/molokai'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"------------------------------------------------------

" for tagbar plugin
let g:tagbar_ctags_bin = "anjuta-tags"
nmap <Leader>tb :TagbarToggle<CR>

" for vim-vala plugin
let vala_comment_strings = 1
let vala_space_errors = 1
"let vala_no_tab_space_error = 1

" disable the polyglot's vala syntax
let g:polyglot_disabled = ['vala']

" for syntastic plugin
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_python_exec = 'python3'
let g:syntastic_mode_map = {'passive_filetypes':['tex', 'rst']}

autocmd! FileType html setlocal sw=2 ts=2 sts=2 expandtab
autocmd! FileType css  setlocal sw=4 ts=2 sts=2 expandtab
autocmd! FileType coffee,javascript setlocal sw=2 ts=2 sts=2 expandtab
autocmd! FileType python setlocal foldmethod=indent expandtab
autocmd! FileType rst setlocal wrap linebreak breakindent

" wrap 時に見た目通りに行移動する
noremap k gk
noremap j gj

" for open-browser plugin
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" for molokai plugin (color scheme)
set t_Co=256
autocmd ColorScheme * hi Comment ctermfg=8
autocmd ColorScheme * hi Visual  ctermbg=12
silent! colorscheme molokai
syntax enable

"コメント行の自動継続 (プラグインで設定されているようなので最後に設定)
set formatoptions+=ro

" Windows用設定
if has('win32')
  set enc=utf-8
  set guifont=IPAゴシック:h12:cSHIFTJIS

  " メニューの文字化け対策
  source $VIMRUNTIME/delmenu.vim
  set langmenu=ja_jp.utf-8
  source $VIMRUNTIME/menu.vim

endif

"" 選択範囲を {%??? ... %} で囲む
"vmap K `>a %}`<i{%key %%
"vmap M `>a %}`<i{%mode %%
"vmap " :s/^"//egv:s/"$//egv:s/\\"/"/eggv:s/``/`/eg:noh
"
"" prep後に .po で適用
"nmap _K /:kbd:df:lvi`K%hx%lx_K
"nmap _M /:ref:df:lvi`Ugv:s/-/ /ggvM%hx%lx_M

vmap _C dkP==ireturn 
vmap _O xiop_or_punct(tw, "pa")
vmap _K xikeyword(tw, "pa")

nmap _P itw.proc(() => {return 
nmap _T ea(tw)
nmap _& a &&
nmap _} o})<<<<
nmap _O :s/\(\w*\)opt(tw)/opt(\1(tw))/g

