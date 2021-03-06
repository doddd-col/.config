                  "__ _       
  "___ ___  _ __  / _(_) __ _ 
 "/ __/ _ \| '_ \| |_| |/ _` |
"| (_| (_) | | | |  _| | (_| |
 "\___\___/|_| |_|_| |_|\__, |
                       "|___/ 

" ===
" === Auto load for first time uses
" ===
if empty(glob('~/.config/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" ===
" === Create a _machine_specific.vim file to adjust machine specific stuff, like python interpreter location
" ===
let has_machine_specific_file = 1
if empty(glob('~/.config/nvim/_machine_specific.vim'))
	let has_machine_specific_file = 0
	silent! exec "!cp ~/.config/nvim/default_configs/_machine_specific_default.vim ~/.config/nvim/_machine_specific.vim"
endif
source ~/.config/nvim/_machine_specific.vim

let $NVIM_PYTHON_LOG_FILE="/tmp/nvim_log"

set nocompatible
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on		" nerdtree required


let mapleader=" "

" 可以使用鼠标
set mouse=a

" 自动切换当前目录为当前文件所在的目录
set autochdir

" 设置编码
set encoding=utf-8

" 是否显示状态栏。0 表示不显示，1 表示只在多窗口时显示，2 表示显示。
set laststatus=2

" 垂直滚动时，光标距离顶部 / 底部的位置（单位：行）。
set scrolloff=5

set t_Co=256


" 基于缩进或语法进行代码折叠
set foldmethod=indent
"set foldmethod=syntax
set nofoldenable

" 再次打开文件回复光标位置
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Press space twice to jump to the next '<++>' and edit it
map <LEADER><LEADER> <Esc>/<++><CR>:nohlsearch<CR>c4i

" Prevent incorrect backgroung rendering
let &t_ut=''

" Press ` to change case (instead of ~)
noremap ` ~


let g:SnazzyTransparent = 1

" ===
" === Editor behavior
" ===

" 不显示状态
set noshowmode
set inccommand=split
" 显示不可打印字符
set list
set listchars=tab:\|\ ,trail:▫

" 补全
set completeopt=longest,noinsert,menuone,noselect,preview

set notimeout
" 记住位置
set viewoptions=cursor,folds,slash,unix

set lazyredraw             " Only redraw when necessary.
syntax on	            " 语法高亮
set number              " 显示行号
set cursorline          " 突出显示当前行
set ruler               " 打开状态栏标尺
set shiftwidth=4        " 设定 << 和 >> 命令移动时的宽度为 4
set softtabstop=4       " 使得按退格键时可以一次删掉 4 个空格
set tabstop=4           " 设定 tab 长度为 4
set relativenumber		" 显示相对行号
set wrap				" 自动换行
set showcmd
set wildmenu			" TAB键补全
set hlsearch			" 高亮搜索
set incsearch			" 边输入边高亮
set ignorecase			" 忽略大小写
set smartcase			" 智能大写
set autoindent			" 回车后保持缩进
set linebreak			" 不会再单词内换行
set wrapmargin=2		" 换行时间隔
set ttyfast "should make scrolling faster
set updatetime=1000 " .vimrc, 根据光标位置自动更新高亮tag的间隔时间，单位为毫秒
set colorcolumn=80
" 修改边界颜色
highlight ColorColumn ctermbg=blue

set virtualedit=block

silent !mkdir -p ~/.config/nvim/tmp/backup
silent !mkdir -p ~/.config/nvim/tmp/undo
silent !mkdir -p ~/.config/nvim/tmp/sessions
set backupdir=~/.config/nvim/tmp/backup,.
set directory=~/.config/nvim/tmp/backup,.

if has('persistent_undo')
	set undofile
	set undodir=~/.config/nvim/tmp/undo,.
endif
" 改变光标
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"


" ===
" === Terminal Behaviors
" ===
let g:neoterm_autoscroll = 1
autocmd TermOpen term://* startinsert
tnoremap <C-N> <C-\><C-N>
tnoremap <C-O> <C-\><C-N><C-O>
let g:terminal_color_0  = '#000000'
let g:terminal_color_1  = '#FF5555'
let g:terminal_color_2  = '#50FA7B'
let g:terminal_color_3  = '#F1FA8C'
let g:terminal_color_4  = '#BD93F9'
let g:terminal_color_5  = '#FF79C6'
let g:terminal_color_6  = '#8BE9FD'
let g:terminal_color_7  = '#BFBFBF'
let g:terminal_color_8  = '#4D4D4D'
let g:terminal_color_9  = '#FF6E67'
let g:terminal_color_10 = '#5AF78E'
let g:terminal_color_11 = '#F4F99D'
let g:terminal_color_12 = '#CAA9FA'
let g:terminal_color_13 = '#FF92D0'
let g:terminal_color_14 = '#9AEDFE'
augroup TermHandling
  autocmd!
  " Turn off line numbers, listchars, auto enter insert mode and map esc to
  " exit insert mode
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber
    \ | startinsert
    \ | tnoremap <Esc> <c-c>
  autocmd FileType fzf call LayoutTerm(0.6, 'horizontal')
augroup END

function! LayoutTerm(size, orientation) abort
  let timeout = 16.0
  let animation_total = 120.0
  let timer = {
    \ 'size': a:size,
    \ 'step': 1,
    \ 'steps': animation_total / timeout
  \}

  if a:orientation == 'horizontal'
    resize 1
    function! timer.f(timer)
      execute 'resize ' . string(&lines * self.size * (self.step / self.steps))
      let self.step += 1
    endfunction
  else
    vertical resize 1
    function! timer.f(timer)
      execute 'vertical resize ' . string(&columns * self.size * (self.step / self.steps))
      let self.step += 1
    endfunction
  endif
  call timer_start(float2nr(timeout), timer.f, {'repeat': float2nr(timer.steps)})
endfunction

" Open autoclosing terminal, with optional size and orientation
function! OpenTerm(cmd, ...) abort
  let orientation = get(a:, 2, 'horizontal')
  if orientation == 'horizontal'
    new | wincmd J
  else
    vnew | wincmd L
  endif
  call LayoutTerm(get(a:, 1, 0.5), orientation)
  call termopen(a:cmd, {'on_exit': {j,c,e -> execute('if c == 0 | close | endif')}})
endfunction
" }}}
" vim:fdm=marker


" ===
" === Cursor Movement
" ===
" New cursor movement (the default arrow keys are used for resizing windows)
"     ^
"     u
" < n   i >
"     e
"     v
noremap <silent> u k
noremap <silent> n h
noremap <silent> e j
noremap <silent> i l

" U/E keys for 5 times u/e (faster navigation)
noremap <silent> U 5k
noremap <silent> E 5j
noremap ; :

noremap k i
noremap K I
noremap N 7h
noremap I 7l
noremap l u
" Faster in-line navigation
noremap W 5w
noremap B 5b

" N key: go to the start of the line
noremap <silent> N 0

" I key: go to the end of the line
noremap <silent> I $

" Indentation
nnoremap < <<
nnoremap > >>

" set h (same as n, cursor left) to 'end of word'
noremap h e

" Ctrl + U or E will move up/down the view port without moving the cursor
noremap <C-U> 5<C-y>
noremap <C-E> 5<C-e>


" Press <SPACE> + q to close the window below the current window
noremap <LEADER>q <C-w>j:q<CR>


" ===
" === Insert Mode Cursor Movement
" ===
inoremap <C-a> <ESC>

" ===
" === Command Mode Cursor Movement
" ===
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
" cnoremap <M-b> <S-Left>
cnoremap <M-w> <S-Right>


" 下/上一个搜索词并回到屏幕中间
noremap = nzz
noremap - Nzz
noremap <LEADER><CR> :nohlsearch<CR>


nnoremap Y y$

vnoremap Y "+y

" Disable the default s key
noremap s <nop>

map S :w<CR>
map Q :q<CR>
map R :source $MYVIMRC<CR>


" ===
" === Window management
" ===
" 窗口切换光标
map <LEADER>i <C-w>l
map <LEADER>u <C-w>k
map <LEADER>n <C-w>h
map <LEADER>e <C-w>j

" 分屏操作
map si :set splitright<CR>:vsplit<CR>
map sn :set nosplitright<CR>:vsplit<CR>
map su :set nosplitbelow<CR>:split<CR>
map se :set splitbelow<CR>:split<CR>

" ===
" === Tab management
" ===
" 修改窗口大小
map <up> :res +5<CR>
map <down> :res -5<CR>
map <left> :vertical resize-5<CR>
map <right> :vertical resize+5<CR>

" Create a new tab with tu
map tu :tabe<CR>
" Move around tabs with tn and ti
map tn :-tabnext<CR>
map ti :+tabnext<CR>
" Move the tabs with tmn and tmi
noremap tmn :-tabmove<CR>
noremap tmi :+tabmove<CR>



" 切换分屏方式
map sv <C-w>t<C-w>H
map sh <C-w>t<C-w>K


" Auto change directory to current dir
autocmd BufEnter * silent! lcd %:p:h

" Opening a terminal window
noremap <LEADER>/ :set splitbelow<CR>:split<CR>:res +10<CR>:term<CR>
" Indentation
nnoremap < <<
nnoremap > >>

call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'KabbAmine/yowish.vim'
Plug 'connorholyday/vim-snazzy'
Plug 'bling/vim-bufferline'

" Genreal Highlighter
Plug 'jaxbot/semantic-highlight.vim'
Plug 'chrisbra/Colorizer' " Show colors with :ColorHighlight
" ===
" === Colorizer
" ===
let g:colorizer_syntax = 1

" vimwiki
Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" find something
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
" ===
" === FZF
" ===
" If installed using Homebrew
"set rtp+=/usr/local/opt/fzf
"
"" If installed using git
"set rtp+=~/.fzf
noremap <C-p> :FZF<CR>
noremap <C-f> :Ag<CR>
noremap <C-h> :MRU<CR>
noremap <C-t> :BTags<CR>
"noremap <C-l> :LinesWithPreview<CR>
"noremap <C-w> :Buffers<CR>
""noremap ; :History:<CR>

autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0 noruler
  \| autocmd BufLeave <buffer> set laststatus=2 ruler

command! -bang -nargs=* Buffers
  \ call fzf#vim#buffers(
  \   '',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:0%', '?'),
  \   <bang>0)


command! -bang -nargs=* LinesWithPreview
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --color=always --smart-case . '.fnameescape(expand('%')), 1,
    \   fzf#vim#with_preview({}, 'up:50%', '?'),
    \   1)

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(
  \   '',
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', '?'),
  \   <bang>0)


command! -bang -nargs=* MRU call fzf#vim#history(fzf#vim#with_preview())

command! -bang BTags
  \ call fzf#vim#buffer_tags('', {
  \     'down': '40%',
  \     'options': '--with-nth 1 
  \                 --reverse 
  \                 --prompt "> " 
  \                 --preview-window="70%" 
  \                 --preview "
  \                     tail -n +\$(echo {3} | tr -d \";\\\"\") {2} |
  \                     head -n 16"'
  \ })



Plug 'fszymanski/fzf-gitignore', { 'do': ':UpdateRemotePlugins' }

" ===
" === fzf-gitignore
" ===
noremap <LEADER>gi :FzfGitignore<CR>

"Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'
" ===================== Start of Plugin Settings =====================
" ==
" == GitGutter
" ==
let g:gitgutter_signs = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_preview_win_floating = 1
autocmd BufWritePost * GitGutter
nnoremap <LEADER>gf :GitGutterFold<CR>
nnoremap H :GitGutterPreviewHunk<CR>
nnoremap <LEADER>g- :GitGutterPrevHunk<CR>
nnoremap <LEADER>g= :GitGutterNextHunk<CR>


" 启动显示
Plug 'mhinz/vim-startify'
" Undo Tree
Plug 'mbbill/undotree'

Plug 'tpope/vim-surround' " type yskw' to wrap the word with '' or type cs'` to change 'word' to `word`

" taglist
Plug 'liuchengxu/vista.vim'
" ===
" === Vista.vim
" ===
noremap <silent> T :Vista!!<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
function! NearestMethodOrFunction() abort
	return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" ===
" === Undotree
" ===
noremap L :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 1
let g:undotree_SetFocusWhenToggle = 1
let g:undotree_ShortIndicators = 1
let g:undotree_WindowLayout = 2
let g:undotree_DiffpanelHeight = 8
let g:undotree_SplitWidth = 24
function g:Undotree_CustomMap()
	nmap <buffer> u <plug>UndotreeNextState
	nmap <buffer> e <plug>UndotreePreviousState
	nmap <buffer> U 5<plug>UndotreeNextState
	nmap <buffer> E 5<plug>UndotreePreviousState
endfunc


" Editor Enhancement
Plug 'jiangmiao/auto-pairs'
Plug 'terryma/vim-multiple-cursors'
" ==
" == vim-multiple-cursor
" ==
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key = '<c-k>'
let g:multi_cursor_select_all_word_key = '<a-k>'
let g:multi_cursor_start_key = 'g<c-k>'
let g:multi_cursor_select_all_key = 'g<a-k>'
let g:multi_cursor_next_key = '<c-k>'
let g:multi_cursor_prev_key = '<c-p>'
let g:multi_cursor_skip_key = '<C-s>'
let g:multi_cursor_quit_key = '<Esc>'
Plug 'scrooloose/nerdcommenter' " in <space>cn to comment a line

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync() }, 'for' :['markdown', 'vim-plug'] }
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'theniceboy/bullets.vim'
" ===
" === Bullets.vim
" ===
"let g:bullets_set_mappings = 0
let g:bullets_enabled_file_types = [
			\ 'markdown',
			\ 'text',
			\ 'gitcommit',
			\ 'scratch'
			\]



Plug 'junegunn/vim-after-object' " da= to delete what's after =
" ===
" === vim-after-object
" ===
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ')

Plug 'luochen1990/rainbow'
" ===
" === rainbow
" ===
let g:rainbow_active = 1
Plug 'junegunn/vim-peekaboo'
" ===
" === Markdown Settings
" ===
" Snippets
source ~/.config/nvim/md-snippets.vim
" auto spell
autocmd BufRead,BufNewFile *.md setlocal spell

" Spelling Check with <space>sc
noremap <LEADER>sc :set spell!<CR>


noremap <LEADER>- :lN<CR>
noremap <LEADER>= :lne<CR>



" Auto Complete
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
" ===
" === coc
" ===
"解决coc.nvim大文件卡死状况
"let g:trigger_size = 0.5 * 1048576
"
"augroup hugefile
  "autocmd!
  "autocmd BufReadPre *
        "\ let size = getfsize(expand('<afile>')) |
        "\ if (size > g:trigger_size) || (size == -2) |
        "\   echohl WarningMsg | echomsg 'WARNING: altering options for this huge file!' | echohl None |
        "\   exec 'CocDisable' |
        "\ else |
        "\   exec 'CocEnable' |
        "\ endif |
        "\ unlet size
"augroup END
"" fix the most annoying bug that coc has
"silent! au BufEnter,BufRead,BufNewFile * silent! unmap if
"let g:coc_global_extensions = ['coc-python', 'coc-java', 'coc-vimlsp', 'coc-html', 'coc-json', 'coc-css', 'coc-tsserver', 'coc-yank', 'coc-lists', 'coc-gitignore', 'coc-vimlsp', 'coc-tailwindcss', 'coc-stylelint', 'coc-tslint', 'coc-lists', 'coc-git', 'coc-explorer', 'coc-pyright', 'coc-sourcekit', 'coc-translator']
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)
"" use <tab> for trigger completion and navigate to the next complete item
"function! s:check_back_space() abort
	"let col = col('.') - 1
	"return !col || getline('.')[col - 1]	=~ '\s'
"endfunction
"inoremap <silent><expr> <Tab>
			"\ pumvisible() ? "\<C-n>" :
			"\ <SID>check_back_space() ? "\<Tab>" :
			"\ coc#refresh()
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
""inoremap <silent><expr> <CR> pumvisible() ? "\<C-y><CR>" : "\<CR>"
"function! s:check_back_space() abort
	"let col = col('.') - 1
	"return !col || getline('.')[col - 1]  =~# '\s'
"endfunction
"inoremap <silent><expr> <c-space> coc#refresh()
"" Text Objects
"xmap kf <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap kf <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)
"" Useful commands
"nnoremap <silent> <space>y :<C-u>CocList -A --normal yank<cr>
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"nmap <leader>rn <Plug>(coc-rename)
"nmap tt :CocCommand explorer<CR>
"" coc-translator
"nmap ts <Plug>(coc-translator-p)
"" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
"
" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" ===
" === Ultisnips
" ===
let g:tex_flavor = "latex"
inoremap <c-n> <nop>
let g:UltiSnipsExpandTrigger="<c-e>"
let g:UltiSnipsJumpForwardTrigger="<c-e>"
let g:UltiSnipsJumpBackwardTrigger="<c-n>"
let g:UltiSnipsSnippetDirectories = [$HOME.'/.config/nvim/Ultisnips/', 'UltiSnips']
silent! au BufEnter,BufRead,BufNewFile * silent! unmap <c-r>

" HTML, CSS, JavaScript, PHP, JSON, etc.
Plug 'elzr/vim-json'
Plug 'hail2u/vim-css3-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'spf13/PIV', { 'for' :['php', 'vim-plug'] }
Plug 'pangloss/vim-javascript', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'yuezk/vim-js', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }
Plug 'jelera/vim-javascript-syntax', { 'for': ['vim-plug', 'php', 'html', 'javascript', 'css', 'less'] }


" ========
" java补全
" ========
"Plug 'artur-shaik/vim-javacomplete2'

Plug 'CodeFalling/fcitx-vim-osx'



Plug 'ajmwagar/vim-deus'

" Always load the vim-devicons as the very last one.
Plug 'ryanoasis/vim-devicons'
call plug#end()

" ===
" === Dress up my vim
" ===
"在执行宏命令时，不进行显示重绘；在宏命令执行完成后，一次性重绘，以便提高性能。
set lazyredraw
set termguicolors	" enable true colors support
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set background=dark

color deus
hi NonText ctermfg=gray guifg=grey10

" ===
" === NERDTree
" ===
map tt :NERDTreeToggle<CR>
let NERDTreeMapOpenExpl = ""
let NERDTreeMapUpdir = ""
let NERDTreeMapUpdirKeepOpen = "l"
let NERDTreeMapOpenSplit = ""
let NERDTreeOpenVSplit = ""
let NERDTreeMapActivateNode = "i"
let NERDTreeMapOpenInTab = "o"
let NERDTreeMapPreview = ""
let NERDTreeMapCloseDir = "n"
let NERDTreeMapChangeRoot = "y"


" ==
" == NERDTree-git
" ==
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ "Unknown"   : "?"
    \ }


set guifont=DroidSansMono_Nerd_Font:h11


" ===
" === MarkdownPreview
" ===
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_echo_preview_url = 0
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
			\ 'mkit': {},
			\ 'katex': {},
			\ 'uml': {},
			\ 'maid': {},
			\ 'disable_sync_scroll': 0,
			\ 'sync_scroll_type': 'middle',
			\ 'hide_yaml_meta': 1
			\ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
let g:mkdp_browser = 'Safari'



" ===
" === vim-table-mode
" ===
map <LEADER>tm :TableModeToggle<CR>
let g:table_mode_cell_text_object_i_map = 'k<Bar>'




" 日志级别,日志文件默认在workspace/eclimd.log
" 除了默认的info,还有trace,debug,warning,error,off
let g:EclimLogLevel = 'info'
" 让eclim配合ycm实现java等语言的自动补全
" 编辑的文件必须是eclipse的一个项目中的文件才会自动补全
" 这个变量的作用是(仅举例java文件):set omnifunc=eclim#java#complete#CodeComplete
let g:EclimCompletionMethod = 'omnifunc'
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" 自动高亮当前光标下的单词
 function! HighlightWordUnderCursor()
    if getline(".")[col(".")-1] !~# '[[:punct:][:blank:]]'
        exec 'match' 'Search' '/\V\<'.expand('<cword>').'\>/'
    else
        match none
    endif
endfunction


" 禁止缓存匹配项，每次都重新生成匹配项
let g:ycm_cache_omnifunc=0
" 语法关键字补全
let g:ycm_seed_identifiers_with_syntax=1


" Compile function
noremap r :call CompileRunGcc()<CR>
func! CompileRunGcc()
	exec "w"
	if &filetype == 'c'
		exec "!g++ % -o %<"
		exec "!time ./%<"
	elseif &filetype == 'cpp'
		set splitbelow
		exec "!g++ -std=c++11 % -Wall -o %<"
		:sp
		:res -15
		:term ./%<
	elseif &filetype == 'java'
		exec "!javac %"
		exec "!time java %<"
	elseif &filetype == 'sh'
		:!time bash %
	elseif &filetype == 'python'
		set splitbelow
		:sp
		:term python3 %
	elseif &filetype == 'html'
		"silent! exec "!".g:mkdp_browser." % &"
		silent! exec '!open %'
	elseif &filetype == 'markdown'
		exec "MarkdownPreview"
	elseif &filetype == 'tex'
		silent! exec "VimtexStop"
		silent! exec "VimtexCompile"
	elseif &filetype == 'go'
		set splitbelow
		:sp
		:term go run %
	endif
endfunc

" Call figlet
noremap tx :r !figlet<space>


" Open the vimrc file anytime
noremap <LEADER>rc :e ~/.config/nvim/init.vim<CR>




" ===================== End of Plugin Settings =====================


" ===
" === Necessary Commands to Execute
" ===
exec "nohlsearch"


" Open the _machine_specific.vim file if it has just been created
if has_machine_specific_file == 0
	exec "e ~/.config/nvim/_machine_specific.vim"
endif
