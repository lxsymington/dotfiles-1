"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global {{{

let mapleader = "\<Space>"

nnoremap <Leader><Leader> <C-^>

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :call CloseOnLast()<CR>
nnoremap <Leader>Q :q<CR>

nnoremap <Leader>n :Files %:h<CR>
nnoremap <Leader>N :E %:h/

nnoremap <Leader>o o<esc>k
nnoremap <Leader>O O<esc>j

nnoremap <Leader>z 1z=

nnoremap <Leader>u :MundoToggle<CR>

nmap <silent> <Leader>c <Plug>qf_qf_stay_toggle

nnoremap <Leader>; :CommaOrSemiColon<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FZF {{{

nnoremap <Leader>p :Buffers<CR>
nnoremap <Leader><C-P> :Commands<CR>
nnoremap <Leader><C-W> :Windows<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Splits {{{

nnoremap <Leader><C-H> :hide<CR>
nnoremap <Leader><C-J> :only<CR>
nnoremap <Leader><C-K> :sv#<CR>
nnoremap <Leader><C-L> :vs#<CR>
nnoremap <Leader><C-O> :Bufonly<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search {{{

" nnoremap <Leader>a :F<Space><Space>**/*.*<Left><Left><Left><Left><Left><Left><Left>
nnoremap <Leader>r :OverCommandLine<CR>%s/\v
vnoremap <Leader>r :OverCommandLine<CR>s/\v

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy Motion {{{

map <Leader>ee <Plug>(easymotion-bd-w)
nmap <Leader>ee <Plug>(easymotion-overwin-w)
nmap <Leader>ef <Plug>(easymotion-overwin-f2)
map <Leader>es <Plug>(incsearch-easymotion-/)\v
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>h <Plug>(easymotion-linebackward)

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git {{{

nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)
nmap <leader>gJ 9999<leader>gj
nmap <leader>gK 9999<leader>gk

nnoremap <Leader>gg :Merginal<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap <Leader>gr :Gread<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gm :Gsdiff :1 \| Gvdiff<CR>
nnoremap <Leader>gl :BCommits<CR>
nnoremap <Leader>gf :GFiles?<CR>
nnoremap <Leader>gt :SignifyToggleHighlight<CR>
nnoremap <Leader>gz :SignifyFold!<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unit Test {{{

function! UnitTest()
    call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
                \ shellescape('npm run test'), shellescape('.bottom')))
endfunction

nnoremap <Leader>ut :call UnitTest()<CR>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Google{{{

function! s:goog(pat, lucky)
    let q = '"'.substitute(a:pat, '["\n]', ' ', 'g').'"'
    let q = substitute(q, '[[:punct:] ]',
                \ '\=printf("%%%02X", char2nr(submatch(0)))', 'g')
    call system(printf('open "https://www.google.com/search?%sq=%s"',
                \ a:lucky ? 'btnI&' : '', q))
endfunction

nnoremap <leader>? :call <SID>goog(expand("<cWORD>"), 0)<cr>
nnoremap <leader>! :call <SID>goog(expand("<cWORD>"), 1)<cr>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux{{{

" " https://github.com/junegunn/dotfiles/blob/ae8388976f8fd7339b717f65b0175d8e4e93aa71/vimrc#L384
" function! s:tmux_send(content, dest) range
"     let dest = empty(a:dest) ? input('To which pane? ') : a:dest
"     let tempfile = tempname()
"     call writefile(split(a:content, "\n", 1), tempfile, 'b')
"     call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
"                 \ shellescape(tempfile), shellescape(dest)))
"     call delete(tempfile)
" endfunction

" function! s:tmux_map_cursor(key, dest)
"     execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
"     execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
" endfunction
" call s:tmux_map_cursor('<leader>tj', '.bottom')

" nnoremap <silent> <leader>tl "tyy:call <SID>tmux_send("npm run lint\n", ".bottom")<cr>
" nnoremap <silent> <leader>tu "tyy:call <SID>tmux_send("npm run test\n", ".bottom")<cr>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim:foldmethod=marker:foldlevel=0

