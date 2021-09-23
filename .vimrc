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

" wrap 時に見た目通りに行移動する
noremap k gk
noremap j gj

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


call plug#begin()
"-- for alignment
Plug 'godlygeek/tabular'
"-- for open browser and preview
Plug 'tyru/open-browser.vim'
Plug 'previm/previm'
"-- for HTML/CSS/JS
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
"-- LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
"-- color scheme
Plug 'tomasr/molokai'
call plug#end()

autocmd! FileType html setlocal sw=2 ts=2 sts=2 expandtab
autocmd! FileType css  setlocal sw=4 ts=2 sts=2 expandtab
autocmd! FileType coffee,javascript setlocal sw=2 ts=2 sts=2 expandtab
autocmd! FileType python setlocal foldmethod=indent expandtab
autocmd! FileType rst setlocal wrap linebreak breakindent

" for open-browser plugin
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" for previm plugin
let g:previm_enable_realtime = 1

" for vim-lsp plugin
function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')

    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

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
