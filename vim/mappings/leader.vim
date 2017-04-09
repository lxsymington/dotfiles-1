"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader = "\<Space>"


" switch to last buffer
nnoremap <Leader><Leader> <C-^>
" open CtrlPBuffer
nnoremap <Leader><C-P> :CtrlPBuffer<CR>
nnoremap <Leader><C-H> :hide<CR>
nnoremap <Leader><C-K> :sv#<CR>
nnoremap <Leader><C-L> :vs#<CR>

" save/close
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :call CloseOnLast()<CR>
nnoremap <Leader>x :x<CR>

" open from dir
nnoremap <Leader>n :edit <C-R>=expand('%:p:h') . '/'<CR>

" Zoom one pane
nnoremap <silent> <Leader>z :! tmux resize-pane -Z<CR><CR> :MaximizerToggle<CR>