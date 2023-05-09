" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Install plug plugins
call plug#begin()

Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-eunuch'
Plug 'macguirerintoul/night_owl_light.vim'

call plug#end()

" Show relative numbers with the current line number
set relativenumber number

" Update faster for git gutter
set updatetime=100

" Enable gui colors
if (has("termguicolors"))
 set termguicolors
endif

" Enable Night Owl Theme
syntax enable
colorscheme night_owl_light

" Enable Night Owl Theme for Airline
let g:airline_theme='night_owl'
