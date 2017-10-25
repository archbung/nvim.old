" Section: Plugins
" Make pathogen.vim be a submodule
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Rust
" Autoformat on every save
let g:rustfmt_autosave = 1

" Scala
" Scaladoc comment using the recommended indentation.
let g:scala_scaladoc_indent = 1

" Haskell
" Optional highlighting
let g:haskell_enable_quantification = 1
" Don't start intero automatically
"let g:intero_start_immediately = 0

" Markdown
" Use pythonic folding
let g:vim_markdown_folding_style_pythonic = 1

" Ledger
" Hide blank lines after transactions
let g:ledger_fold_blanks = 1

" VimTex
let g:tex_flavor = 'latex'

" Ale
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

" Coquille

" SnipMate
" Use Python 3.x
let g:UltiSnipsUsePythonVersion = 3

" Trigger configuration
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-z>"

" Vertical split
let g:UltiSnipsEditSplit = "vertical"

" CtrlP
" Use ripgrep
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif
set wildignore+=*/tmp/*,*.swp,*.so,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" Exclude files in gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Lightline
" Modeline configurations
let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename'] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'linter_warnings', 'linter_errors', 'linter_ok' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'fileformat': 'LightlineFileformat',
      \   'filetype': 'LightlineFiletype',
      \   'filename': 'LightlineFilename',
      \   'readonly': 'LightlineReadonly',
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK'
      \ },
      \ 'component_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \   'linter_ok': 'ok'
      \ },
      \ }

" Update modeline everytime ALE does its thing
autocmd User ALELint call lightline#update()

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d --', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d >>', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓' : ''
endfunction

" Trim the fileformat and encoding info on narrow windows
function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

" Trim the bar between filename and modified sign
function! LightlineFilename()
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return filename . modified
endfunction

" Hide readonly info on 'Help'
function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction


" Section: Various settings
" Enabling filetype support provides filetype-specific indenting, syntax
" highlighting, omni-completion and other useful settings.
filetype plugin indent on
syntax on

" True colors ftw
set termguicolors
colorscheme landscape

" 'matchit.vim' is built-in so let's enable it!
" Hit '%' on 'if' to jump to 'else'.
runtime macros/matchit.vim


set autoindent			            " Minimal automatic indenting for any filetype.
set backspace=indent,eol,start	" Proper backspace behavior
set hidden			                " Possibility to have more than one
                     			      " unsaved buffers.
set incsearch			              " Incremental searc
set ruler			                  " Shows current line numbers at the bottom
                                " right of the screen
set wildmenu			              " Great command-line completion, use '<Tab>' to
				                        " move around and '<CR>' to validate.

set cpoptions+=J		            " Two spaces after sentences.
set splitright			            " New ':vsplit' on the right
set splitbelow			            " New ':split' below

set autowriteall		            " Autowrite on all commands e.g. ':edit',
				                        " ':enew', ':next', etc
set ignorecase			
set smartcase			

set textwidth=80		
set formatoptions=q,r,n,1

set noshowmode                  " Mode is indicated by lightline.vim
set lazyredraw


" Section: Keybindings
let g:mapleader="\<Space>"
let g:maplocalleader="\\"
nnoremap j gj
nnoremap k gk
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

tnoremap <C-[> <C-\><C-n>

" Allow saving of files when forget to sudo
cmap w!! w !sudo tee > /dev/null %


" Section: Autocmds
" Remember last cursor position
augroup basic
  autocmd!
  " go to insert mode when it's terminal buffer
  autocmd BufEnter *
        \ if &buftype == 'terminal' | :startinsert | endif
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

augroup vimrc
	autocmd!
	autocmd Filetype vim setlocal tabstop=2 
        \ softtabstop=2 shiftwidth=2 expandtab 
augroup END

augroup tex
  autocmd!
  autocmd Filetype tex setlocal tabstop=2
        \ softtabstop=2 shiftwidth=2 noexpandtab
augroup END

augroup cpp
  autocmd!
  autocmd Filetype c,cpp setlocal tabstop=8
        \ softtabstop=8 shiftwidth=8 noexpandtab
augroup END

augroup pencil
  autocmd!
  autocmd Filetype markdown,mkd,text call pencil#init()
augroup END

augroup ledger
  autocmd!
  autocmd BufNewFile,BufRead *.ledger set filetype=ledger
  autocmd Filetype ledger setlocal tabstop=4
        \ softtabstop=4 shiftwidth=4 noexpandtab
augroup END

augroup haskell
  autocmd!
  " Background process and window management
  autocmd Filetype haskell nnoremap <silent> <leader>is :InteroStart<CR>
  autocmd Filetype haskell nnoremap <silent> <leader>ik :InteroKill<CR>
  
  " Intero split horizontally
  autocmd Filetype haskell nnoremap <silent> <leader>io :InteroOpen<CR>
  " Intero split vertically
  autocmd Filetype haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
  autocmd Filetype haskell nnoremap <silent> <leader>ih :InteroHide<CR>

  " Reload on save
  autocmd BufWritePost *.hs InteroReload

  " Load individual modules
  autocmd Filetype haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
  autocmd Filetype haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

  " Type-related information
  autocmd Filetype haskell map <silent> <leader>t <Plug>InteroGenericType
  autocmd Filetype haskell map <silent> <leader>T <Plug>InteroType
  autocmd Filetype haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>

  " Navigation
  autocmd Filetype haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>

  " Managing targets with prompt
  autocmd Filetype haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
augroup END

augroup coq
  autocmd!
  " Use FN mappings
  autocmd Filetype coq call coquille#FNMapping()

  autocmd Filetype coq setlocal tabstop=4
        \ softtabstop=4 shiftwidth=4 expandtab
augroup END

" vim:set foldmethod=expr foldexpr=getline(v\:lnum)=~'^\"\ Section\:'?'>1'\:getline(v\:lnum)=~#'^fu'?'a1'\:getline(v\:lnum)=~#'^endf'?'s1'\:'=':
