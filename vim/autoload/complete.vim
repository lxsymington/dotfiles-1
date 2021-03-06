
function! complete#Undouble()
    let l:col  = getpos('.')[2]
    let l:line = getline('.')
    call setline('.', substitute(l:line, '\(\.\?\k\+\)\%'.l:col.'c\zs\1', '', ''))
endfunction

function! complete#ReturnToOldPath()
    if exists('b:oldpwd')
        cd `=b:oldpwd`
        unlet b:oldpwd
    endif
endfunction
