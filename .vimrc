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

"全角記号の幅を広く
set ambiwidth=double

" wrap 時に見た目通りに行移動する
noremap k gk
noremap j gj

" netrw の設定
let g:netrw_winsize = 10

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
"-- for Markdown
Plug 'preservim/vim-markdown'
"-- for open browser and preview
Plug 'tyru/open-browser.vim'
" Plug 'previm/previm'
"-- for HTML/CSS/JS
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
"-- for git
Plug 'tpope/vim-fugitive'
"-- LSP
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
"-- Auto complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
"-- color scheme
Plug 'tomasr/molokai'
"-- GitHub Copilot
Plug 'github/copilot.vim'
call plug#end()

" autocmd! FileType html setlocal sw=2 ts=2 sts=2 expandtab
" autocmd! FileType css  setlocal sw=4 ts=2 sts=2 expandtab
" autocmd! FileType coffee,javascript setlocal sw=2 ts=2 sts=2 expandtab
autocmd! FileType python setlocal foldmethod=indent expandtab
" autocmd! FileType rst setlocal wrap linebreak breakindent

" for open-browser plugin
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" for previm plugin
let g:previm_enable_realtime = 1

" for molokai plugin (color scheme)
set t_Co=256
autocmd ColorScheme * hi Comment ctermfg=8
autocmd ColorScheme * hi Visual  ctermbg=12
silent! colorscheme molokai
syntax enable

" for vim-lsp
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
    nnoremap <buffer> <expr><c-j> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-k> lsp#scroll(-4)
	xnoremap <buffer> = <Plug>(lsp-document-range-format)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 50
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_echo_delay = 50
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_highlights_delay = 50
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0
let g:lsp_diagnostics_signs_enabled = 1
let g:lsp_diagnostics_signs_delay = 50
" let g:lsp_diagnostics_signs_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_delay = 50
let g:lsp_diagnostics_virtual_text_align = "right"
let g:lsp_diagnostics_virtual_text_insert_mode_enabled = 1
let g:lsp_completion_documentation_delay = 40
let g:lsp_document_highlight_delay = 100
let g:lsp_document_code_action_signs_delay = 100
" let g:lsp_fold_enabled = 0
set foldmethod=expr
  \ foldexpr=lsp#ui#vim#folding#foldexpr()
  \ foldtext=lsp#ui#vim#folding#foldtext()


augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

" let g:lsp_settings_root_markers = [
" \   '.venv/',
" \   '.git',
" \   '.git/',
" \   '.svn',
" \   '.hg',
" \   '.bzr'
" \ ]

"コメント行の自動継続 (プラグインで設定されているようなので最後に設定)
set formatoptions+=ro

" https://superuser.com/questions/1291425/windows-subsystem-linux-make-vim-use-the-clipboard
" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system("iconv -f utf8 -t cp932 | ".s:clip, @0) | endif
    augroup END
endif
