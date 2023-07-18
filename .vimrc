execute pathogen#infect()
execute pathogen#helptags()

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
" Plug 'dense-analysis/ale'
Plug 'jpalardy/vim-slime'
Plug 'tpope/vim-fugitive'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'Yggdroot/indentLine'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'yaocccc/nvim-hlchunk'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'preservim/nerdtree'
" Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
" Plug 'thesis/vim-solidity'
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Plug 'eliba2/vim-node-inspect'
" Plug 'tom-doerr/vim_codex'
" Plug 'madox2/vim-ai', { 'do': './install.sh' }
" Snippets are separated from the engine. Add this if you want them:
"Plug 'honza/vim-snippets'
Plug 'terryma/vim-multiple-cursors', {'branch': 'master'}
call plug#end()

let g:indent_blankline_enabled = v:true

set background=dark

nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
nnoremap <silent> <leader>d :call CocAction('doHover')<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>f :call CocAction('format')<cr>
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

let g:asyncomplete_auto_completeopt = 0
" set completeopt=menuone,noinsert

if executable('hoon-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'hoon-language-server',
        \ 'cmd': ['hoon-language-server'],
        \ 'whitelist': ['hoon'],
        \ })
endif

colorscheme apprentice
let mapleader = ","


" Deferred match parens: https://github.com/andymass/vim-matchup#deferred-highlighting
let g:matchup_matchparen_deferred = 1
hi MatchParen ctermbg=blue guibg=lightblue cterm=italic gui=italic

if &term =~ '256color'
	" Disable Background Color Erase (BCE) so that color schemes
	" work properly when Vim is used inside tmux and GNU screen.
	set t_ut=
endif
set termguicolors

" Match parens
set showmatch
hi MatchParen gui=bold guibg=blue guifg=blue
" hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" Shared X11 Clipboard
if has('unix')
	if has('mac')       " osx
		set clipboard=unnamed
	else                " linux, bsd, etc
		set clipboard=unnamedplus
	endif
endif

let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc$',  '\.o$', '^__pycache__$', '.*\.js$', '.*\.map$', 'node_modules', '\.git$', '\.svn$']
nnoremap <Leader>n :NERDTreeFind<CR>
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*

" Use silver surfer for grep
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
" command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|redraw!

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
" vnoremap K :grep! "<C-R>"" %<CR>

" bind \ (backward slash) to grep shortcut
nnoremap \ :Ag<SPACE>

" Navigate buffers
nnoremap <bs> <c-^>

" Light cursor column
" set cursorcolumn

" FZF
set rtp+=~/.fzf
set rtp+=/usr/local/opt/fzf
command! MakeTags silent !ctags -R --exclude=/git --exclude=node_modules .
nnoremap <C-p> :Files<CR>
nnoremap <C-t> :Tags<CR>
nnoremap <leader><tab> :BLines<CR>
nnoremap <leader>q :BTags<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
command! -bang -nargs=* Fd
			\ call fzf#vim#ag(<q-args>,
			\                 <bang>0 ? fzf#vim#with_preview('up:40%')
			\                         : fzf#vim#with_preview('right:50%:hidden', '?'),
			\                 <bang>0)
command! -bang -nargs=? -complete=dir Files
			\ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
let g:fzf_history_dir = '~/.local/share/fzf-history'
let g:fzf_colors =
			\ { 'fg':      ['fg', 'Normal'],
			\ 'bg':      ['bg', 'Normal'],
			\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
			\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
			\ 'info':    ['fg', 'PreProc'],
			\ 'border':  ['fg', 'Ignore'],
			\ 'prompt':  ['fg', 'Conditional'],
			\ 'pointer': ['fg', 'Exception'],
			\ 'marker':  ['fg', 'Keyword'],
			\ 'spinner': ['fg', 'Label'],
			\ 'header':  ['fg', 'Comment'] }

" PyDocString
let g:pydocstring_templates_dir = '~/.vim/bundle/vim-pydocstring/test/templates/numpy'
nmap <silent> <C-_> <Plug>(pydocstring)

" Buffer back/forward like C-o and C-I
" nmap <leader>r :bp<CR>
" nmap <leader>f :bn<CR>

" GFM
let g:vim_markdown_preview_browser='Google Chrome'
let g:vim_markdown_preview_github=1

" Undo
if has("persistent_undo")
	set undodir=~/.undodir/
	set undofile
endif

" ,y and ,p for cross-vim clipboard w/o X11
vmap <leader>y :w! /tmp/vitmp<CR>
nmap <leader>p :r! cat /tmp/vitmp<CR>

" Create session, continue w/ vim -S
" nnoremap <leader>s :mksession<CR>
"
" Git blame for current line
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

" NERDTree
nnoremap <leader>k :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.ipynb$', '\.png$', '\.jpeg$', '\.jpg$', '\.JPEG$', '\.JPG$', '\.pkl$', '\.ckpt$']

" TagBar
" nnoremap <F8> :TagbarToggle<CR>
" let g:tagbar_compact = 1
" let g:tagbar_show_linenumbers = 1
" let g:tagbar_autopreview = 0
" let g:tagbar_sort = 0
" let g:tagbar_autofocus = 1
" let g:tagbar_autoclose = 1
" set previewheight=25

" Folding for Python; should move this to ftplugin
nnoremap <space> za
vnoremap <space> zf
nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

" Hybrid Line Numbers
set nu
" set number relativenumber

"  Yank/Paste clipboard
" nnoremap <C-y> "+y
" vnoremap <C-y> "+y
" nnoremap <C-p> "+gP
" vnoremap <C-p> "+gP
set pastetoggle=<F2>

" Move to normal mode when using arrows
inoremap <silent> <Up> <ESC><Up>
inoremap <silent> <Down> <ESC><Down>

" Make jj ESC
inoremap jj <Esc>

" Toggle gutter shit
nnoremap <F5> <esc>:set nonumber<CR>:set nofoldenable<CR>
nnoremap <F6> <esc>:set number<CR>:set foldenable<CR>

" Clear highlighting on ESC in normal
" nnoremap <esc> :noh<return>:SyntasticReset<return>:ALEReset<return>:cclose<return><esc>
" nnoremap <esc> :noh<return>:ALEReset<return>:cclose<return>:pclose<return><esc>
nnoremap <esc> :noh<return>:cclose<return>:pclose<return><esc>
nnoremap <esc>^[ <esc>^[

" Seems criminal but...
" set mouse=a

" Vim Slimeness
let g:slime_target = "tmux"
let g:slime_python_ipython = 1

" Vim Markdown conceals stuff. Don't.  Also don't fold.
" set nofoldenable
let g:vim_markdown_conceal = 0
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_fenced_languages = ['bash=sh', 'shell=sh', 'c++=cpp', 'viml=vim', 'ini=dosini']

" Pandoc
" let g:pandoc#syntax#conceal#use = 0

" Enable spell checking for markdown files
au BufRead *.md setlocal spell
au BufRead *.mdown setlocal spell

" Python highlighting
let g:python_highlight_all = 1

" Goyo Distraction free editing
let g:goyo_height = '100%'
let g:goyo_width = '90%'
let g:goyo_pads = 0
nnoremap <Leader>z :Goyo<CR>i<Esc>`^

" Documentation
"let g:pymode_doc = 1
let g:pymode_doc_key = 'D'

" Syntax
filetype on
syntax on
set ignorecase
set smartcase

" Search highlight/Incremental
set hlsearch
set incsearch
set modelines=0
set wildmenu
set wildmode=longest:full

filetype plugin indent on

set fillchars=vert:│    " that's a vertical box-drawing character
" UTF-8
set encoding=utf-8

" " ALE
" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '(%code%): %s' " '[%linter%] %s [%severity%]'
" let g:ale_python_pycodestyle_options = '--max-line-length 90'
" let g:ale_linters = {
" 	\'python': ['flake8'],
" 	\'javascript': ['eslint'],
" 	\}
" let g:ale_fixers = {
" 	\   'javascript': ['eslint'],
" 	\   'json': ['fixjson'],
" 	\   'python': ['black'],
" 	\   'cpp': ['clang-format', 'remove_trailing_lines', 'trim_whitespace']
" \}
" " let g:ale_python_flake8_executable = 'python'
" let g:ale_python_flake8_executable = '/home/parag/anaconda3/bin/flake8'
" let g:ale_python_flake8_options = '--ignore=E501,W503,E231,E203,W605 --max-line-length=100'
" let g:ale_open_list = 1
" " let g:ale_keep_list_window_open = 0
" let g:ale_lint_on_save = 1
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_insert_leave = 0
" let g:ale_lint_on_enter = 0
" nnoremap <leader>l :ALELint<CR>
" nnoremap <leader>L :ALEFix<CR>

" C++
autocmd FileType cpp nnoremap <buffer><leader>L :ClangFormat<Cr><C-o>

" Javascript
let g:javascript_plugin_jsdoc = 1
let g:jsx_ext_required = 0

" UndoTree
nnoremap <leader>u <ESC>:UndotreeToggle<cr>
let g:undotree_HighlightChangedText = 1
let g:undotree_HighlightSyntaxAdd = "DiffAdd"
let g:undotree_HighlightSyntaxChange = "DiffChange"
let g:undotree_WindowLayout = 2

"" tab shortcuts
nnoremap <C-b>  :tabprevious<CR>
nnoremap <C-B>  :tabnext<CR>
nnoremap <C-c>  :tabnew<CR>
nnoremap <C-x>  :tabclose<CR>

" Easier Pane Navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Moving around in wrapped lines:
autocmd FileType html,markdown,text nnoremap <expr> j v:count ? 'j' : 'gj'
autocmd FileType html,markdown,text nnoremap <expr> k v:count ? 'k' : 'gk'
autocmd FileType html,markdown,text vnoremap <expr> j v:count ? 'j' : 'gj'
autocmd FileType html,markdown,text vnoremap <expr> k v:count ? 'k' : 'gk'

" set listchars=tab:\|\
" set list

" Last place editing
if has("autocmd")
	au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
				\| exe "normal! g'\"" | endif
endif

" Retab 2 -> 4
nnoremap <leader>t <ESC>:set ts=2 noet<CR>:retab!<CR>:set et ts=4<CR>:retab<CR>
vnoremap <leader>t <ESC>:set ts=2 noet<CR>:'<,'>retab!<CR>:set et ts=4<CR>:'<,'>retab<CR>

nnoremap <leader>T <ESC>:set ts=4 noet<CR>:retab!<CR>:set et ts=2<CR>:retab<CR>
vnoremap <leader>T <ESC>:set ts=4 noet<CR>:'<,'>retab!<CR>:set et ts=2<CR>:'<,'>retab<CR>

" Turn off automatic visual selection w/ mouse
set mouse-=a

" Delays
set timeoutlen=1000 ttimeoutlen=0

" Tired of lowercasing stuff by mistake
vnoremap u :noh<cr>

let g:indent_guides_enable_on_vim_startup = 1
" let g:indent_guides_start_level = 2
" let g:indent_guides_guide_size = 1
" let g:indentLine_char = '┆'

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
   let @/ = ''
   if exists('#auto_highlight')
     au! auto_highlight
     augroup! auto_highlight
     setl updatetime=4000
     echo 'Highlight current word: off'
     return 0
  else
    augroup auto_highlight
    au!
    au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
  return 1
 endif
endfunction

" Indent line hides quotes in json files
let g:indentLine_fileTypeExclude = ['json']
let g:vim_json_syntax_conceal = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_conceal_code_blocks = 0

" gitgutter updates
set updatetime=1
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" codex
nnoremap  <C-x> :CreateCompletion<CR>
inoremap  <C-x> <Esc>li<C-g>u<Esc>l:CreateCompletion<CR>

" Redraw hacks to force refresh
set lazyredraw
set ttyfast

" Force reload files
set autoread

" Italize documentation
highlight Comment cterm=italic gui=italic

set mouse=

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Disable python2 support
let g:loaded_python_provider = 0

" Don't enable explicitly python3 it doesn't work and disables python3
" this only works for DISABLE, python3 is enabled by default
" let g:loaded_python3_provider = 1

" set the route of the executable
let g:python3_host_prog = '/usr/local/bin/python3'

" Explicitly tells to neovim use python3 when evaluate python code
set pyxversion=3
