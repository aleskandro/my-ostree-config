if exists("g:loaded_nerdtree_plugin_open")
    finish
endif
let g:loaded_nerdtree_plugin_open = 1

function! s:callback_name()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_') . 'callback'
endfunction

function! s:callback()
    try
        let path = g:NERDTreeFileNode.GetSelected().path.str({'escape': 1})
    catch
        return
    endtry

    if exists("g:nerdtree_plugin_open_cmd")
        let cmd = g:nerdtree_plugin_open_cmd . " " . path
        call system(cmd)
    endif
endfunction

call NERDTreeAddKeyMap({
    \ 'callback': s:callback_name(),
    \ 'quickhelpText': 'open with external programm',
    \ 'key': 'E',
    \ })
