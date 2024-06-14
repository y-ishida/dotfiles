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
" Plug 'previm/previm'
"-- for HTML/CSS/JS
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'
"-- for git
Plug 'tpope/vim-fugitive'
"-- LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"-- color scheme
Plug 'tomasr/molokai'
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

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


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

" https://superuser.com/questions/1291425/windows-subsystem-linux-make-vim-use-the-clipboard
" WSL yank support
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system("iconv -f utf8 -t cp932 | ".s:clip, @0) | endif
    augroup END
endif
