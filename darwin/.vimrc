" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Personal config
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set ignorecase
set number
set smartcase
set title
" Don't unload hidden buffers
set hidden

" Bells are annoying
set belloff=all

" Parse mac files
set ffs=unix,dos,mac

" Update find path to search subdirectories
set path=$PWD/**

" Files to ignore
" Temp files
set wildignore+=*.swp,~*
" Python
set wildignore+=*.pyc,*/__pycache__/*
" Terraform
set wildignore+=*.terraform
" Version control
set wildignore+=.git/

" Wrapping
set whichwrap+=h,l

" Tab sanity
set tabstop=4
autocmd FileType javascript setlocal shiftwidth=2
set shiftwidth=4
set expandtab

" Update more frequently
set updatetime=300

" Sign column always visible
set signcolumn=yes

" Show hidden characters
set list
set listchars=tab:→\ ,trail:·,nbsp:·

" Highlight long lines
set colorcolumn=80,120

let mapleader='\'

" Search for visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR> 
vnoremap <leader>s y:%s/\V<C-R>=escape(@",'/\')<CR>//g<left><left>

" Navigation w/ space
nmap <space> <C-F>
nmap <leader><space> <C-B>

" Inverse vim logic of first char on line
nnoremap 0 ^
nnoremap ^ 0

" Quick write and close
nmap <leader>w :w<CR>
nmap <leader>q :q<CR>
" Quick word substitution
nmap <leader>s :%s/<C-r><C-w>//gc<left><left><left>
" copy to clipboard
nmap <leader>y "*y
vmap <leader>y "*y
nmap <leader>a :%y*<CR>

" Create links in markdown! Copies whatever is in the clipboard (in macos) now
" and pastes it as a markdown formatted link
nmap <leader>l ysiw]%a()<left><D-v><ESC>
vmap <leader>l S]%a()<left><D-v><ESC>

command Preview :!open -a "warp" %<TAB>

" Spelling
nnoremap <leader>z :set spell!<CR>
set spelllang=sv,en

" Navigate quicklist
nmap <leader>n :cnext<CR>
nmap <leader>p :cprevious<CR>
" And location list
nmap <leader>N :lnext<CR>
nmap <leader>P :lprevious<CR>

" cd
nnoremap <leader>cd :lcd %:p:h<CR>
" Highlight search
nmap <leader>hl :set hlsearch!<CR>

" Reload file
nmap <leader>rf :edit!<CR>

" Source vimrc
nmap <leader>rc :source ~/.vimrc<CR>

" Abbreviations
abbreviate ttoday <C-r>=strftime('%F')<CR>
abbreviate tnow <C-r>=strftime('%X')<CR>
abbreviate twl ## Week of <C-r>=strftime('%F', localtime() - (str2nr(strftime('%w')) - 1) * 24 * 60 * 60)<CR><CR><CR>### Did<CR><CR><CR>### Learned

" Paste from clipboard
function! TogglePaste()
  if &paste
    set nopaste
  else
    set paste
    startinsert
  endif
endfunction
nnoremap <leader>e :call TogglePaste()<CR>

" Run line in shell
nmap <leader>! 0y$:!<C-R>"<CR>

" Open current file with system default app
nmap <leader>% :!open %<CR>

" Vimdiff shortcuts
nmap <leader>1 :diffget LOCAL<CR>
nmap <leader>2 :diffget BASE<CR>
nmap <leader>3 :diffget REMOTE<CR>

" Clipboard pasting
map <leader>y "*y
map <leader>p "*pp

" Don't exit visual on indentation
vmap < <gv
vmap > >gv

" Fetch session if exists and not opening anything else
autocmd StdinReadPre * let s:std_in=1
if argc() == 0 && !exists("s:std_in") && filereadable("Session.vim") 
  silent source Session.vim
endif

fun! s:readtime()
    let l:status = v:statusmsg
    try
        exe "silent normal! g\<C-g>"
        echo printf('%s; ~%.1fm',
                    \ v:statusmsg, 
                    \ wordcount()['words'] / 250.0)
    finally
        let v:statusmsg = l:status
    endtry
endfun
nnoremap g<C-g> :call <SID>readtime()<CR>

let mapleader='\'
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Plugin Installation
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" General
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Colorscheme
Plug 'danilo-augusto/vim-afterglow'
" Statusline
Plug 'itchyny/lightline.vim'

" Sessions
Plug 'tpope/vim-obsession'
" Text-objects!
Plug 'wellle/targets.vim'
" Extend match `%` param to tags
Plug 'https://github.com/adelarsq/vim-matchit'

" Navigation
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

" Git
Plug 'tpope/vim-fugitive'
" Git sign change
Plug 'mhinz/vim-signify'

" Markdown TOC
Plug 'mzlogin/vim-markdown-toc'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" Python syntax
Plug 'vim-python/python-syntax'

" Lint engine. Note that lint-engines need to be installed for ale to work
Plug 'dense-analysis/ale', {'for': ['python', 'css', 'html', 'javascript', 'terraform', 'yaml']}

call plug#end()

" Colorscheme
set t_Co=256
colorscheme afterglow



" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Plugin configuration
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" vim-commentary
autocmd FileType tf setlocal commentstring=#\ %s

" Terraform config
" let g:terraform_fmt_on_save=1
"
" Nerdtree launch on empty or no session
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif

" Open nerdtree with C-n
map <C-n> :NERDTreeToggle<CR>

" Show hidden files by default
let g:NERDTreeShowHidden=1
" But ignore wildignores
let g:NERDTreeRespectWildIgnore=1

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('tf', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('py', 'Red', 'none', '#ffa500', '#151515')

" ALE Configuration
let g:ale_fixers = {
\    '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'css': ['prettier'],
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\   'python': ['black', 'isort'],
\   'yaml': ['prettier'],
\}
let g:ale_linters = {
\   'css': ['prettier'],
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\   'python': ['flake8'],
\   'terraform': ['tflint'],
\   'yaml': ['prettier'],
\}
let g:ale_fix_on_save = 1

let g:python_highlight_all = 1

" Documentation
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

" Signify signs
let g:signify_sign_change            = '~'
let g:signify_sign_delete            = '-'

" Lightline git plug
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly'],
      \             [ 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename',
      \ },
      \ }

function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction
