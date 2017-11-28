"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Close Buffer {{{

function! OpenBufferNumber()
    let cnt = 0
    for i in range(0, bufnr("$"))
        if buflisted(i)
            let cnt += 1
        endif
    endfor
    return cnt
endfunction

function! CloseOnLast()
    if OpenBufferNumber() <= 1
        q
    else
        call undoquit#SaveWindowQuitHistory()
        bd
    endif
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Strip trailing whitespace {{{

function! s:StripTrailingWhitespaces()
    let l:l = line(".")
    let l:c = col(".")
    %s/\s\+$//e
    call cursor(l:l, l:c)
endfunction

augroup stripWhitespaces
    autocmd!
    autocmd stripWhitespaces BufWritePre * :call s:StripTrailingWhitespaces()
augroup END

augroup stripWhitespaces
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != "gitcommit" | exe "normal! g'\"" | endif
augroup END

au CursorHold * checktime

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Root {{{

function! <SID>AutoProjectRootCD()
    try
        if &ft != 'help'
            ProjectRootCD
        endif
    catch
        " Silently ignore invalid buffers
    endtry
endfunction

autocmd BufEnter * call <SID>AutoProjectRootCD()

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Japanese {{{

let g:input_toggle = 0
function! FcitxToEn()
    let s:input_status = system("fcitx-remote")
    if s:input_status == 2
        let g:input_toggle = 1
        let l:a = system("fcitx-remote -c")
    endif
endfunction

function! FcitxToJp()
    let s:input_status = system("fcitx-remote")
    if s:input_status != 2 && g:input_toggle == 1
        let l:a = system("fcitx-remote -o")
        let g:input_toggle = 0
    endif
endfunction

autocmd InsertLeave * call FcitxToEn()
autocmd InsertEnter * call FcitxToJp()

function! ToggleInput()
    if g:input_toggle
        let g:input_toggle=0
    else
        let g:input_toggle=1
    endif
endfunction

command Japanese :call ToggleInput()

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Clear Registers {{{

" https://stackoverflow.com/a/26043227
function! ClearRegisters()
    redir => l:register_out
    silent register
    redir end
    let l:register_list = split(l:register_out, '\n')
    call remove(l:register_list, 0) " remove header (-- Registers --)
    call map(l:register_list, "substitute(v:val, '^.\\(.\\).*', '\\1', '')")
    call filter(l:register_list, 'v:val !~ "[%#=.:]"') " skip readonly registers
    for elem in l:register_list
        execute 'let @'.elem.'= ""'
    endfor
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Make Dir {{{

" https://github.com/junegunn/fzf.vim/issues/89#issuecomment-187764499
function s:MKDir(...)
    if         !a:0
           \|| stridx('`+', a:1[0])!=-1
           \|| a:1=~#'\v\\@<![ *?[%#]'
           \|| isdirectory(a:1)
           \|| filereadable(a:1)
           \|| isdirectory(fnamemodify(a:1, ':p:h'))
        return
    endif
    return mkdir(fnamemodify(a:1, ':p:h'), 'p')
endfunction
command -bang -bar -nargs=? -complete=file E :call s:MKDir(<f-args>) | e<bang> <args>

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Restore Session {{{

fu! RestoreSession()
if filereadable(getcwd() . '/Session.vim') && &filetype != "gitcommit"
    execute 'so ' . getcwd() . '/Session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endif
endfunction

autocmd VimEnter * nested call RestoreSession()

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quick Fix{{{

function! QuickFix()
    let list = ['quickfix', 'help', 'nofile']
    if (index(list, &buftype) >= 0)
        let g:qs_enable = 0
        " match Error /.*/
        " syntax match Error /|.*|/
        " syntax match Error /\d*\scol\s\d*/
        if &buftype == 'quickfix'
            match Error /|/
            syntax match qfFileName /^[^|]*/ transparent conceal
            syntax match qfError /error\(|\s\|\s\d*|\s\)/ transparent conceal
            syntax match qfCol /\d*\scol\s\d*/ transparent conceal
        endif
    else
        let g:qs_enable = 1
    endif
endfunction

augroup QuickFix
    autocmd!
    autocmd BufWinEnter,BufEnter,cursormoved * call QuickFix()
augroup END

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Undoubled Completion{{{

augroup Undouble_Completions
    autocmd!
    autocmd CompleteDone *  call Undouble_Completions()
augroup END

function! Undouble_Completions ()
    let col  = getpos('.')[2]
    let line = getline('.')
    call setline('.', substitute(line, '\(\.\?\k\+\)\%'.col.'c\zs\1', '', ''))
endfunction

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fold Text{{{

function! FoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))

    let [added, modified, removed] = sy#repo#get_stats()
    if added > 0 || modified > 0 || removed > 0 || len(getqflist()) > 0 || len(signature#mark#GetList('used', 'buf_all')) > 0
        let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 2
    else
        let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    endif

    return '➔ ' . line . repeat(" ",fillcharcount) . foldedlinecount . ' '
endfunction
set foldtext=FoldText()

" }}}
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim:foldmethod=marker:foldlevel=0

