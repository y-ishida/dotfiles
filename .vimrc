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

Plugin 'plasticboy/vim-markdown'
Plugin 'tyru/open-browser.vim'
Plugin 'kannokanno/previm'

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

" for open-browser plugin
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" for molokai plugin (color scheme)
set t_Co=256
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

" 選択範囲を {%??? ... %} で囲む
vmap K `>a %}`<i{%key %%
vmap M `>a %}`<i{%mode %%
vmap " :s/^"//egv:s/"$//egv:s/\\"/"/eggv:s/``/`/eg:noh

" prep後に .po で適用
nmap _K /:kbd:df:lvi`K%hx%lx_K
nmap _M /:ref:df:lvi`Ugv:s/-/ /ggvM%hx%lx_M

